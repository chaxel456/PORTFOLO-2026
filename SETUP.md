# N.W.A. SMILE — Real-time Supabase Setup

This version is no longer based on browser localStorage. Projects, media and enquiries are stored in Supabase, with Supabase Auth, Row Level Security, Storage and Realtime.

## 1. Create the Supabase project
Create a Supabase project.

## 2. Run `supabase-schema.sql`
Open Supabase → SQL Editor → paste/run the complete SQL file.

It creates:
- `profiles`
- `projects`
- `media`
- `enquiries`
- `site_settings`
- `page_views` visitor analytics
- `project-media` Storage bucket
- Row Level Security policies
- Realtime publication for projects/media/enquiries

## 3. Create the administrator
Supabase → Authentication → Users → Add user.

Create the admin email and password.

Copy the user's UUID.

Then run the admin profile statement near the bottom of `supabase-schema.sql`, replacing `YOUR_ADMIN_AUTH_USER_UUID`.

Only users with an `admin` profile can create/edit/delete projects, upload media or read enquiries.

## 4. Configure the frontend
Open `supabase-config.js`:

window.SUPABASE_CONFIG = {
  url: "https://YOUR-PROJECT.supabase.co",
  anonKey: "YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY"
};

Use only the public anon/publishable key in frontend code.

NEVER expose:
- service_role key
- secret key
- database password
- SMTP password

## 5. What is realtime now?
When the admin publishes/edits/deletes a project:
- Supabase saves it
- public website receives the database event
- public Project Library refreshes

When media is uploaded:
- file goes to Supabase Storage
- media record goes to `media`
- public Media section updates through Realtime

When a visitor visits the website, the public site records an anonymous session/page view in `page_views`; the admin dashboard shows total views, unique visitors and recent anonymous activity.

Visitor names are not guessed or harvested. A name is shown in the dashboard only when the person voluntarily submits a project enquiry.

When a visitor submits an enquiry:
- enquiry is stored in `enquiries`
- admin dashboard receives it through Realtime
- Gmail compose opens with a prepared copy for the visitor to review/send

## 6. Gmail detail
The browser cannot securely send email through a private Gmail account.

The current secure approach:
1. Save enquiry in Supabase.
2. Open Gmail compose with recipient/subject/body prefilled.
3. Visitor presses Send.

For true automatic delivery to Gmail without opening Gmail, the next step is a server-side email function, e.g. a Supabase Edge Function using a transactional email provider or authenticated Gmail API.

## 7. Recommended architecture
For this portfolio, Supabase is the best first backend:

Public website
   ↓
Supabase JS
   ↓
PostgreSQL + Storage + Realtime

Admin
   ↓
Supabase Auth
   ↓
RLS-protected database/storage

This avoids maintaining a separate server just for CRUD, authentication and media.

If N.W.A. SMILE later needs complex business logic, quotations, invoices, staff accounts, payments, construction scheduling or external integrations, a dedicated FastAPI backend can be added in front of the same PostgreSQL database.

## 8. Deploy
Deploy the static files to Netlify, Vercel, Cloudflare Pages, etc.

Set the production site URL in Supabase Authentication URL/redirect settings.

Use HTTPS.

## 9. Before launch
- Change/create a strong admin password.
- Add only trusted admin users.
- Verify RLS policies.
- Replace placeholder contact details.
- Add real project photos/videos.
- Configure the email delivery function if automatic email is required.
