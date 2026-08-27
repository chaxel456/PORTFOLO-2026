-- N.W.A. SMILE — Supabase database setup
-- Run this whole file in Supabase SQL Editor.
-- IMPORTANT: create the first admin user in Authentication > Users first,
-- then replace YOUR_ADMIN_AUTH_USER_UUID below with that user's UUID.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'admin' check (role in ('admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  location text,
  type text not null default 'Residential',
  status text not null default 'Draft' check (status in ('Completed','Ongoing','Draft')),
  year integer,
  description text,
  cover_image_url text,
  featured boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.media (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  title text not null,
  media_type text not null check (media_type in ('Photo','Video')),
  url text not null,
  storage_path text,
  thumbnail_url text,
  created_at timestamptz not null default now()
);

create table if not exists public.enquiries (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text,
  phone text,
  project_type text,
  location text,
  budget text,
  message text not null,
  status text not null default 'New' check (status in ('New','Contacted','Closed')),
  created_at timestamptz not null default now()
);

create table if not exists public.site_settings (
  id integer primary key default 1 check (id = 1),
  company_name text not null default 'N.W.A. SMILE',
  whatsapp text,
  enquiry_email text,
  updated_at timestamptz not null default now()
);

insert into public.site_settings (id)
values (1)
on conflict (id) do nothing;

-- Admin profile. Replace the UUID before running this statement.
-- insert into public.profiles (id, full_name, role)
-- values ('YOUR_ADMIN_AUTH_USER_UUID', 'N.W.A. SMILE Administrator', 'admin')
-- on conflict (id) do update set role='admin';

-- Helper function for RLS.
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

-- updated_at trigger
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists projects_updated_at on public.projects;
create trigger projects_updated_at
before update on public.projects
for each row execute function public.set_updated_at();

drop trigger if exists settings_updated_at on public.site_settings;
create trigger settings_updated_at
before update on public.site_settings
for each row execute function public.set_updated_at();

alter table public.profiles enable row level security;
alter table public.projects enable row level security;
alter table public.media enable row level security;
alter table public.enquiries enable row level security;
alter table public.site_settings enable row level security;

-- Profiles: admins can read their own profile.
drop policy if exists "admins read own profile" on public.profiles;
create policy "admins read own profile"
on public.profiles for select
to authenticated
using (id = auth.uid());

-- Projects: public can see only published projects; admins can do everything.
drop policy if exists "public read published projects" on public.projects;
create policy "public read published projects"
on public.projects for select
to anon, authenticated
using (status <> 'Draft' or public.is_admin());

drop policy if exists "admins insert projects" on public.projects;
create policy "admins insert projects"
on public.projects for insert to authenticated
with check (public.is_admin());

drop policy if exists "admins update projects" on public.projects;
create policy "admins update projects"
on public.projects for update to authenticated
using (public.is_admin()) with check (public.is_admin());

drop policy if exists "admins delete projects" on public.projects;
create policy "admins delete projects"
on public.projects for delete to authenticated
using (public.is_admin());

-- Media: public may read media belonging to published projects; admins can manage.
drop policy if exists "public read published media" on public.media;
create policy "public read published media"
on public.media for select
to anon, authenticated
using (
  public.is_admin()
  or exists (
    select 1 from public.projects p
    where p.id = media.project_id and p.status <> 'Draft'
  )
);

drop policy if exists "admins insert media" on public.media;
create policy "admins insert media"
on public.media for insert to authenticated
with check (public.is_admin());

drop policy if exists "admins update media" on public.media;
create policy "admins update media"
on public.media for update to authenticated
using (public.is_admin()) with check (public.is_admin());

drop policy if exists "admins delete media" on public.media;
create policy "admins delete media"
on public.media for delete to authenticated
using (public.is_admin());

-- Enquiries: visitors can submit; only admins can read/manage.
drop policy if exists "public submit enquiries" on public.enquiries;
create policy "public submit enquiries"
on public.enquiries for insert
to anon, authenticated
with check (true);

drop policy if exists "admins read enquiries" on public.enquiries;
create policy "admins read enquiries"
on public.enquiries for select to authenticated
using (public.is_admin());

drop policy if exists "admins update enquiries" on public.enquiries;
create policy "admins update enquiries"
on public.enquiries for update to authenticated
using (public.is_admin()) with check (public.is_admin());

drop policy if exists "admins delete enquiries" on public.enquiries;
create policy "admins delete enquiries"
on public.enquiries for delete to authenticated
using (public.is_admin());

-- Settings: public can read; only admins can update.
drop policy if exists "public read settings" on public.site_settings;
create policy "public read settings"
on public.site_settings for select
to anon, authenticated
using (true);

drop policy if exists "admins update settings" on public.site_settings;
create policy "admins update settings"
on public.site_settings for update to authenticated
using (public.is_admin()) with check (public.is_admin());


-- Anonymous visitor analytics. No IP address or personal identity is stored.
create table if not exists public.page_views (
  id uuid primary key default gen_random_uuid(),
  session_id text not null,
  page_path text not null default '/',
  referrer text,
  created_at timestamptz not null default now()
);

alter table public.page_views enable row level security;

drop policy if exists "public log page views" on public.page_views;
create policy "public log page views"
on public.page_views for insert
to anon, authenticated
with check (length(session_id) between 10 and 100 and length(page_path) <= 500);

drop policy if exists "admins read page views" on public.page_views;
create policy "admins read page views"
on public.page_views for select
to authenticated
using (public.is_admin());

-- Realtime analytics functions. These are callable only by admins.
create or replace function public.get_visitor_stats()
returns table(total_views bigint, unique_visitors bigint, known_visitors bigint)
language sql
stable
security definer
set search_path = public
as $$
  select
    count(*)::bigint,
    count(distinct session_id)::bigint,
    (select count(distinct lower(coalesce(email, phone, name))) from public.enquiries)::bigint
  from public.page_views
  where public.is_admin();
$$;

revoke all on function public.get_visitor_stats() from public;
grant execute on function public.get_visitor_stats() to authenticated;

do $$
begin
  alter publication supabase_realtime add table public.page_views;
exception when duplicate_object then null;
end $$;

-- Storage bucket for project photos/videos.
insert into storage.buckets (id, name, public)
values ('project-media', 'project-media', true)
on conflict (id) do update set public = true;

drop policy if exists "public read project media" on storage.objects;
create policy "public read project media"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'project-media');

drop policy if exists "admins upload project media" on storage.objects;
create policy "admins upload project media"
on storage.objects for insert
to authenticated
with check (bucket_id = 'project-media' and public.is_admin());

drop policy if exists "admins update project media" on storage.objects;
create policy "admins update project media"
on storage.objects for update
to authenticated
using (bucket_id = 'project-media' and public.is_admin())
with check (bucket_id = 'project-media' and public.is_admin());

drop policy if exists "admins delete project media" on storage.objects;
create policy "admins delete project media"
on storage.objects for delete
to authenticated
using (bucket_id = 'project-media' and public.is_admin());

-- Realtime publication: dashboard/public pages can receive changes immediately.
do $$
begin
  alter publication supabase_realtime add table public.projects;
exception when duplicate_object then null;
end $$;

do $$
begin
  alter publication supabase_realtime add table public.media;
exception when duplicate_object then null;
end $$;

do $$
begin
  alter publication supabase_realtime add table public.enquiries;
exception when duplicate_object then null;
end $$;
