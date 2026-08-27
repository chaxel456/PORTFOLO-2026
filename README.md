# N.W.A. SMILE Architecture Portfolio

## Pages
- `index.html` — public portfolio
- `admin.html` — admin dashboard prototype
- `assets/logo.png` — N.W.A. SMILE logo

## Admin features
- Dashboard statistics
- Add, edit and delete projects
- Completed / ongoing / draft statuses
- Residential / commercial / institutional / renovation categories
- Search and filters
- Featured projects
- Add/remove photo and video media metadata
- Company, WhatsApp and enquiry-email settings
- Public website link

## Demo login
Username: `admin`
Password: `nwa2026`

## Important
This is a frontend prototype. Login and project data use browser `sessionStorage/localStorage` and are not secure for production. The next stage should connect the dashboard to a real backend (for example FastAPI + PostgreSQL), JWT authentication and cloud image/video storage. Then an admin can securely push projects from any device and visitors will receive them from the API.
