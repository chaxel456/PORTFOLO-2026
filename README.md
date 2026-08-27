# Architecture Portfolio Website

A modern, responsive and professional architecture portfolio website designed to showcase architectural projects, services, achievements and professional information while providing a real-time administrative system for managing the website.

The platform includes a public portfolio website, secure admin dashboard, project enquiry system, visitor analytics, WhatsApp contact integration and real-time data management powered by Supabase.

---

## 🚀 Features

### 🌐 Public Website

* Modern architecture-focused landing page
* Responsive design for:

  * Desktop
  * Tablet
  * Mobile
* Hero section
* About section
* Architecture/project portfolio
* Project details
* Services section
* Contact section
* Project enquiry form
* WhatsApp contact button
* Professional animations and transitions
* SEO-friendly structure
* Fast-loading interface

---

## 🏗️ Project Portfolio

The website allows architectural projects to be displayed professionally.

Each project can contain:

* Project title
* Project category
* Project description
* Project location
* Project images
* Project date
* Project status
* Additional project information

Projects can be managed from the admin dashboard without modifying the website source code.

---

## 📩 Project Enquiry System

Visitors can submit project enquiries directly from the website.

The enquiry form can collect information such as:

* Name
* Email
* Phone number
* Project type
* Budget
* Location
* Message

After submission:

1. The enquiry is stored in Supabase.
2. The enquiry becomes available in the admin dashboard.
3. The website can notify the administrator through email.
4. Visitors can also contact the business directly through WhatsApp.

This makes the website function as an actual business lead-generation platform rather than just a portfolio.

---

## 💬 WhatsApp Integration

A dedicated WhatsApp contact option is available on the website.

Visitors can click the WhatsApp button to start a conversation directly.

Example:

```text
Hello, I would like to make an enquiry about your architectural services.
```

The WhatsApp integration provides a fast communication channel between potential clients and the architecture business.

---

## 📧 Gmail Enquiry Notifications

Project enquiries can be forwarded to the administrator's email.

When a visitor submits an enquiry, the system can send an email containing:

* Visitor name
* Email address
* Phone number
* Project type
* Budget
* Location
* Message
* Date/time of enquiry

This ensures that new client enquiries are not missed.

---

# 🔐 Admin Dashboard

The website includes a protected administrative dashboard.

Administrators can log in and manage website information from one location.

### Dashboard capabilities

* Secure admin login
* Dashboard overview
* Project management
* Add projects
* Edit projects
* Delete projects
* View enquiries
* View visitor statistics
* View visitor information
* Monitor website activity
* Manage portfolio content

---

## 👥 Visitor Analytics

The system is designed to provide information about people visiting the website.

The dashboard can display:

* Total visitors
* Current/active visitors
* Returning visitors
* Visitor names where voluntarily provided
* Visit timestamps
* Pages visited
* Device information
* Browser information
* Referrer/source
* Project pages viewed

### Privacy

Visitor information should only be collected where appropriate and with proper notice/consent. The system should not attempt to secretly identify anonymous visitors.

---

# ⚡ Real-Time Data

The website is designed to work with real-time data instead of demo/static information.

Supabase provides:

* PostgreSQL database
* Authentication
* Real-time database updates
* Secure API access
* Row Level Security
* Database management

For example, when a new enquiry is submitted, the administrator dashboard can receive the update without requiring a manual page refresh.

---

# 🗄️ Database

The project uses **Supabase PostgreSQL** for persistent application data.

Possible database structure:

```text
users
├── id
├── email
├── role
└── created_at

projects
├── id
├── title
├── description
├── category
├── location
├── image_url
├── status
└── created_at

enquiries
├── id
├── name
├── email
├── phone
├── project_type
├── budget
├── location
├── message
├── status
└── created_at

visitors
├── id
├── name
├── session_id
├── page
├── device
├── browser
├── referrer
└── visited_at
```

The actual schema can be adjusted as the application develops.

---

# 🔑 Authentication

Admin authentication is handled securely.

The administrator should not be able to access the dashboard without authentication.

Authentication responsibilities include:

* Admin login
* Session management
* Protected dashboard routes
* Logout
* Password security
* Authorization
* Database access control

Supabase Authentication can be used together with Row Level Security policies to prevent unauthorized users from accessing administrative data.

---

# 🛡️ Security

Security is an important part of the application.

The project should implement:

* Supabase Row Level Security (RLS)
* Protected admin routes
* Secure authentication
* Environment variables
* Server-side handling of sensitive operations
* Input validation
* Form validation
* Protection against unauthorized database access
* Secure email configuration
* No exposed secret keys in frontend code

### Environment variables

Sensitive credentials should be stored in `.env` files and should never be committed to GitHub.

Example:

```env
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=

SUPABASE_SERVICE_ROLE_KEY=

EMAIL_USER=
EMAIL_PASSWORD=

NEXT_PUBLIC_WHATSAPP_NUMBER=
```

Only public variables should be exposed to the browser.

---

# 🧰 Technology Stack

## Frontend

* React
* Next.js
* JavaScript/TypeScript
* HTML5
* CSS
* Responsive UI
* Modern animation libraries where required

## Backend / Services

* Supabase
* PostgreSQL
* Supabase Authentication
* Supabase Realtime
* Supabase Storage where required

## Communication

* WhatsApp
* Gmail/email service

## Deployment

* GitHub
* Netlify

---

# 📁 Project Structure

A typical structure may look like:

```text
architecture-portfolio/
│
├── public/
│   ├── images/
│   ├── projects/
│   └── icons/
│
├── src/
│   ├── components/
│   ├── pages/
│   ├── sections/
│   ├── dashboard/
│   ├── services/
│   ├── lib/
│   └── styles/
│
├── .env.local
├── .gitignore
├── package.json
├── README.md
└── ...
```

The exact structure depends on the current framework configuration.

---

# ⚙️ Local Development

## 1. Clone the repository

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
```

Move into the project directory:

```bash
cd architecture-portfolio
```

---

## 2. Install dependencies

```bash
npm install
```

---

## 3. Configure environment variables

Create:

```text
.env.local
```

Add the required Supabase and application credentials.

Example:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

Never commit `.env.local` to GitHub.

---

## 4. Start the development server

```bash
npm run dev
```

Open:

```text
http://localhost:3000
```

---

# 🧪 Production Build

Before deployment, test the production build:

```bash
npm run build
```

Then run:

```bash
npm start
```

---

# 🚀 Deployment

The project is designed to be deployed through **Netlify** with the source code maintained on **GitHub**.

### Deployment workflow

```text
Local Development
       ↓
      Git
       ↓
    GitHub
       ↓
    Netlify
       ↓
   Live Website
       ↓
    Supabase
```

Whenever changes are pushed to the configured GitHub branch, Netlify can automatically build and deploy the latest version.

---

# 🌍 Netlify Configuration

Set the required environment variables inside:

```text
Netlify
→ Site configuration
→ Environment variables
```

Add the same production credentials required by the application.

Do not upload `.env.local` to GitHub.

---

# 🔄 Real-Time Architecture

The application follows this general architecture:

```text
                 ┌──────────────────┐
                 │     VISITOR      │
                 └────────┬─────────┘
                          │
                          ▼
                 ┌──────────────────┐
                 │  PORTFOLIO SITE  │
                 └────────┬─────────┘
                          │
             ┌────────────┼────────────┐
             │            │            │
             ▼            ▼            ▼
         Enquiry       WhatsApp      Visitor
          Form          Contact      Tracking
             │
             ▼
        ┌───────────┐
        │  Supabase │
        │ PostgreSQL│
        └─────┬─────┘
              │
              ▼
       ┌───────────────┐
       │ Admin Dashboard│
       └───────────────┘
              │
              ▼
        Gmail Notification
```

---

# 📊 Admin Dashboard Flow

```text
Admin
  │
  ▼
Login
  │
  ▼
Authentication
  │
  ▼
Dashboard
  │
  ├── Overview
  ├── Projects
  ├── Enquiries
  ├── Visitors
  ├── Analytics
  └── Settings
```

---

# 📈 Future Improvements

The platform can later be extended with:

* Advanced visitor analytics
* Google Analytics integration
* Project search and filtering
* Project categories
* Client testimonials
* Blog/news section
* Admin notifications
* Email templates
* Multiple administrator accounts
* Role-based permissions
* Image optimization
* Cloud image storage
* Contact form spam protection
* SEO optimization
* Sitemap generation
* Google Search Console integration
* Progressive Web App support

---

# 🧑‍💻 Development Workflow

Recommended workflow:

```bash
git pull
npm install
npm run dev
```

After making changes:

```bash
git add .
git commit -m "Update website"
git push
```

Netlify can then deploy the updated version automatically.

---

# 🐛 Troubleshooting

### Admin cannot log in

Check:

1. Supabase Authentication configuration.
2. Admin account exists.
3. Email/password are correct.
4. Supabase URL is correct.
5. Supabase public key is correct.
6. RLS policies are correctly configured.
7. Environment variables are available to the application.

---

### Database data is not appearing

Check:

* Supabase project status
* Database table names
* RLS policies
* Supabase credentials
* Browser console
* Network requests
* Realtime configuration

---

### Enquiry is not being received

Check:

* Form validation
* Supabase `enquiries` table
* RLS policies
* Email service configuration
* Server-side email credentials
* Netlify environment variables

---

# 📌 Important Security Rule

Never put sensitive credentials directly inside frontend source code.

Do **NOT** commit:

```text
.env
.env.local
SUPABASE_SERVICE_ROLE_KEY
EMAIL_PASSWORD
PRIVATE_API_KEYS
```

Use environment variables instead.

---

# 📄 License

This project is a private/professional portfolio application. Reuse, redistribution or commercial modification should only be done with the permission of the project owner.

---

## 👨‍💻 Project Status

**Status:** Active Development

The project is being developed into a fully functional production architecture portfolio platform with real-time database functionality, secure administration, visitor analytics, project management and client enquiry communication.

---

## ⭐ Vision

The goal is to transform the website from a simple architecture portfolio into a complete digital business platform where potential clients can:

**Discover → Explore Projects → Make Enquiries → Contact via WhatsApp → Become Clients**

while the administrator can:

**Monitor → Manage → Respond → Analyze → Grow**

---

**Built with modern web technologies and designed for real-world production use.**
