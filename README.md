# Piping Engineering Co., Ltd — Website

A single-page corporate website (`index.html`) for a district heating / water
supply pipeline engineering company, with a real backend (Supabase: Postgres
database + authentication) for project requests, contact messages, and all
admin-managed content.

Until the backend is connected, the site still opens and displays normally
using the bundled example content — but submitting a request/message or
using the admin panel requires the backend to be set up first.

## Setting up the backend (one-time, ~10 minutes)

### 1. Create a Supabase project

1. Go to [supabase.com](https://supabase.com) and sign up (free tier is enough).
2. Click **New Project**. Pick any name/region/database password (save that
   password somewhere safe — it's separate from the site's admin login).
3. Wait ~2 minutes for the project to finish provisioning.

### 2. Run the database schema

1. In your new project, open **SQL Editor** (left sidebar) → **New query**.
2. Open `supabase/schema.sql` from this repository, copy its entire contents,
   paste into the SQL editor, and click **Run**.
3. This creates every table the site needs (project requests, contact
   messages, services, projects, equipment, certificates, team, company
   settings) with Row Level Security policies already configured:
   - Site visitors can submit a project request or a contact message, and
     read published public content — nothing else.
   - Only a signed-in admin can read/write everything.

### 3. Create the admin login

1. Go to **Authentication → Users** (left sidebar) → **Add user**.
2. Enter the email and password you want to use to log into the site's admin
   panel, and create the user. (Leave "Auto Confirm User" checked so it's
   ready to use immediately.)
3. This is now your real admin login — there is no password stored anywhere
   in the site's code.

### 4. Connect the site to your project

1. In Supabase, go to **Project Settings → Data API** (or **API** on older
   projects). Copy the **Project URL** and the **anon / public** key.
   (The anon key is meant to be public — it's safe to put in client-side
   code. Never use the `service_role` key here; that one is a real secret.)
2. Open `index.html` in this repository and find this block near the top of
   the `<script>` section:
   ```js
   const SUPABASE_URL = "https://YOUR-PROJECT-REF.supabase.co";
   const SUPABASE_ANON_KEY = "YOUR-PUBLIC-ANON-KEY";
   ```
3. Replace both values with what you copied, save, and redeploy/refresh the
   site.

That's it — the site now talks to your real database. Log into the admin
panel (footer → **ADMIN**) with the email/password you created in step 3.

## What's still client-side only

- **Rate limiting on admin login** is handled by Supabase's own
  authentication service (it throttles repeated failed attempts
  automatically) — nothing to configure.
- The language preference (MN/EN) and the homepage statistics counter
  animation state are stored in the visitor's browser (`localStorage`) since
  they're per-visitor UI preferences, not shared data.
- Uploaded files in the project request form are tracked as name/size/type
  metadata only — the actual file bytes are not uploaded or stored anywhere
  (there was no file storage requirement in the original spec). If you need
  visitors' actual files, that would mean adding Supabase Storage — ask if
  you want that added.

## Local development

No build step. Open `index.html` directly in a browser, or serve the folder
with any static file server. `assets/logo.png` must sit next to `index.html`.
