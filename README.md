# Piping Engineering Co., Ltd — Website

A single-page corporate website (`index.html`) for a district heating / water
supply pipeline engineering company, with a real backend (Supabase: Postgres
database + authentication) for project requests, contact messages, and all
admin-managed content.

## Backend status: connected

The site is already wired up to a live Supabase project
(`euncxsudjrapofzxniiz`) — `SUPABASE_URL` and `SUPABASE_ANON_KEY` in
`index.html` point at it, and `supabase/schema.sql` has been applied (every
table exists with Row Level Security policies active: visitors can submit a
project request or contact message and read published public content;
nothing else). The database advisor was run after setup and comes back
clean of exploitable issues.

The same example content that was bundled as the offline fallback (8
services, 6 example projects, 7 equipment items) has also been seeded into
the live database, so the site looks complete right away — edit or replace
any of it from the admin panel once you're logged in.

**One remaining manual step — create your admin login:**

1. In the [Supabase dashboard](https://supabase.com/dashboard/project/euncxsudjrapofzxniiz),
   go to **Authentication → Users** → **Add user**.
2. Enter the email and password you want to use to log into the site's admin
   panel (footer → **ADMIN**), and create the user. Leave "Auto Confirm User"
   checked so it's ready to use immediately.
3. This is your real admin login — there is no password stored anywhere in
   the site's code. (This step can't be done for you here since it needs an
   agent tool for creating Supabase Auth users, which isn't available in this
   session — everything else has been set up already.)

If you ever need to point the site at a *different* Supabase project (e.g.
for a fresh environment), the config block is near the top of the
`<script>` section in `index.html`:
```js
const SUPABASE_URL = "https://euncxsudjrapofzxniiz.supabase.co";
const SUPABASE_ANON_KEY = "sb_publishable_...";
```
Get the values from **Project Settings → Data API** in that project, and
re-run `supabase/schema.sql` against it first (SQL Editor → New query → paste
→ Run). The anon/publishable key is meant to be public — safe to commit in
client-side code. Never put a `service_role` key or database password here;
those are the actual secrets.

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
