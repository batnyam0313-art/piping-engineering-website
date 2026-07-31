-- =====================================================================
-- Piping Engineering Co., Ltd — Supabase schema
--
-- Run this once in your Supabase project's SQL Editor (Dashboard -> SQL
-- Editor -> New query -> paste this whole file -> Run). It creates every
-- table the site needs, turns on Row Level Security, and sets policies so:
--   - anonymous site visitors can submit project requests and contact
--     messages, and read published public content, but cannot read other
--     visitors' submissions or write to anything else
--   - only a signed-in admin (via Supabase Auth) can read/write everything
-- =====================================================================

create extension if not exists "pgcrypto";

-- ===================== PROJECT REQUESTS =====================
create table if not exists project_requests (
  id uuid primary key default gen_random_uuid(),
  request_id text unique not null,
  company_name text not null,
  contact_person text not null,
  phone text not null,
  email text not null,
  location text not null,
  work_type text not null,
  pipe_type text,
  diameter text,
  pipeline_length text,
  start_date text,
  description text,
  files jsonb not null default '[]',
  status text not null default 'NEW',
  internal_notes jsonb not null default '[]',
  activity jsonb not null default '[]',
  created_at timestamptz not null default now()
);

alter table project_requests enable row level security;

create policy "anon can submit project requests"
  on project_requests for insert
  to anon
  with check (true);

create policy "admin full access to project requests"
  on project_requests for all
  to authenticated
  using (true)
  with check (true);

-- ===================== CONTACT MESSAGES =====================
create table if not exists contact_messages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  company text,
  phone text not null,
  email text not null,
  message text not null,
  read boolean not null default false,
  created_at timestamptz not null default now()
);

alter table contact_messages enable row level security;

create policy "anon can submit contact messages"
  on contact_messages for insert
  to anon
  with check (true);

create policy "admin full access to contact messages"
  on contact_messages for all
  to authenticated
  using (true)
  with check (true);

-- ===================== SERVICES =====================
create table if not exists services (
  id uuid primary key default gen_random_uuid(),
  number text,
  title_mn text not null,
  title_en text not null,
  desc_mn text,
  desc_en text,
  image text,
  scope_mn text,
  scope_en text,
  process_mn text,
  process_en text,
  capability_mn text,
  capability_en text,
  qc_mn text,
  qc_en text,
  published boolean not null default true,
  sort_order integer not null default 0
);

alter table services enable row level security;

create policy "anon can read published services"
  on services for select
  to anon
  using (published = true);

create policy "admin full access to services"
  on services for all
  to authenticated
  using (true)
  with check (true);

-- ===================== PROJECTS =====================
create table if not exists projects (
  id uuid primary key default gen_random_uuid(),
  title_mn text not null,
  title_en text not null,
  category text not null,
  location text,
  year text,
  work_type text,
  pipeline_type text,
  diameter text,
  length text,
  hero_image text,
  gallery jsonb not null default '[]',
  before_image text,
  after_image text,
  challenge_mn text,
  challenge_en text,
  solution_mn text,
  solution_en text,
  scope_mn text,
  scope_en text,
  quality_control_mn text,
  quality_control_en text,
  result_mn text,
  result_en text,
  published boolean not null default true,
  featured boolean not null default false
);

alter table projects enable row level security;

create policy "anon can read published projects"
  on projects for select
  to anon
  using (published = true);

create policy "admin full access to projects"
  on projects for all
  to authenticated
  using (true)
  with check (true);

-- ===================== EQUIPMENT =====================
create table if not exists equipment (
  id uuid primary key default gen_random_uuid(),
  category text not null,
  name_mn text not null,
  name_en text not null,
  desc_mn text,
  desc_en text,
  spec_mn text,
  spec_en text,
  image text,
  published boolean not null default true
);

alter table equipment enable row level security;

create policy "anon can read published equipment"
  on equipment for select
  to anon
  using (published = true);

create policy "admin full access to equipment"
  on equipment for all
  to authenticated
  using (true)
  with check (true);

-- ===================== CERTIFICATES =====================
create table if not exists certificates (
  id uuid primary key default gen_random_uuid(),
  title_mn text not null,
  title_en text not null,
  issuer text,
  image text,
  published boolean not null default true
);

alter table certificates enable row level security;

create policy "anon can read published certificates"
  on certificates for select
  to anon
  using (published = true);

create policy "admin full access to certificates"
  on certificates for all
  to authenticated
  using (true)
  with check (true);

-- ===================== TEAM =====================
create table if not exists team (
  id uuid primary key default gen_random_uuid(),
  name_mn text not null,
  name_en text not null,
  role_mn text,
  role_en text,
  photo text,
  published boolean not null default true
);

alter table team enable row level security;

create policy "anon can read published team"
  on team for select
  to anon
  using (published = true);

create policy "admin full access to team"
  on team for all
  to authenticated
  using (true)
  with check (true);

-- ===================== COMPANY SETTINGS (single row) =====================
create table if not exists company_settings (
  id integer primary key default 1,
  hero_title_mn text,
  hero_desc_mn text,
  about_p1_mn text,
  about_p2_mn text,
  company_phone text,
  company_email text,
  company_address text,
  working_hours text,
  project_phone text,
  facebook_url text,
  instagram_url text,
  linkedin_url text,
  footer_desc text,
  seo_title text,
  seo_description text,
  google_maps_url text,
  constraint single_row check (id = 1)
);

alter table company_settings enable row level security;

create policy "anon can read company settings"
  on company_settings for select
  to anon
  using (true);

create policy "admin full access to company settings"
  on company_settings for all
  to authenticated
  using (true)
  with check (true);

-- Seed the single settings row with the site's existing defaults so the
-- public site has something to display immediately after setup.
insert into company_settings (
  id, hero_title_mn, hero_desc_mn, about_p1_mn, about_p2_mn,
  company_phone, company_email, company_address, working_hours, project_phone,
  facebook_url, instagram_url, linkedin_url, footer_desc,
  seo_title, seo_description, google_maps_url
) values (
  1,
  'ШУГАМ ХООЛОЙН <span class="hl">ИНЖЕНЕРИЙН ЦОГЦ ШИЙДЭЛ</span>',
  'Дулаан болон ус хангамжийн шугам хоолойн угсралт, засвар шинэчлэл, инженерийн ажлыг мэргэжлийн түвшинд гүйцэтгэнэ.',
  'Пайпинг Инженеринг ХХК нь дулаан болон ус хангамжийн инженерийн шугам хоолойн угсралт, засвар шинэчлэл, техникийн шийдлийн чиглэлээр үйл ажиллагаа явуулдаг инженерийн компани юм.',
  'Бид төслийн техникийн шаардлага, инженерийн шийдэл, ажлын чанар болон аюулгүй ажиллагааг эрхэмлэн ажилладаг.',
  '+976 7000 1234',
  'info@pipingengineering.mn',
  'Улаанбаатар хот, Сүхбаатар дүүрэг, Инженерийн гудамж 12',
  'Даваа - Баасан, 09:00 - 18:00',
  '+976 9911 2233',
  'https://facebook.com/',
  'https://instagram.com/',
  'https://linkedin.com/',
  'Дулаан болон ус хангамжийн шугам хоолойн инженерийн шийдэл гаргадаг мэргэжлийн компани.',
  'Piping Engineering Co., Ltd | Шугам хоолойн инженерийн цогц шийдэл',
  'Пайпинг Инженеринг ХХК - дулаан болон ус хангамжийн шугам хоолойн угсралт, засвар шинэчлэл, инженерийн ажлыг мэргэжлийн түвшинд гүйцэтгэнэ.',
  'https://www.google.com/maps/search/?api=1&query=Ulaanbaatar+Mongolia'
)
on conflict (id) do nothing;

-- ===================== REQUEST ID GENERATION =====================
-- Generates PE-<year>-0001 style IDs, resetting the counter each new year,
-- safely under concurrent submissions (a client-side "count existing rows"
-- approach can collide if two people submit at the same moment; this
-- upsert-with-returning is atomic in Postgres and cannot).
create table if not exists request_id_counters (
  year text primary key,
  counter integer not null default 0
);

-- RLS stays enabled with no policies: this table is only ever touched
-- through the SECURITY DEFINER function below, never directly by clients.
alter table request_id_counters enable row level security;

create or replace function next_request_id()
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  yr text := to_char(now(), 'YYYY');
  n integer;
begin
  insert into request_id_counters(year, counter) values (yr, 1)
  on conflict (year) do update set counter = request_id_counters.counter + 1
  returning counter into n;
  return 'PE-' || yr || '-' || lpad(n::text, 4, '0');
end;
$$;

grant execute on function next_request_id() to anon, authenticated;

-- Auto-fill request_id on insert so the client never has to generate it
-- itself (and can't collide with another visitor submitting at the same time).
create or replace function set_request_id()
returns trigger
language plpgsql
as $$
begin
  if new.request_id is null then
    new.request_id := next_request_id();
  end if;
  return new;
end;
$$;

drop trigger if exists trg_set_request_id on project_requests;
create trigger trg_set_request_id
  before insert on project_requests
  for each row
  execute function set_request_id();

-- The "anon can submit project requests" INSERT policy (with check (true))
-- only restricts which rows can be inserted, not what values go into them --
-- a visitor could otherwise POST straight to the REST API and set status,
-- internal_notes, or activity directly (e.g. fabricating a fake "approved by
-- admin" note). Force these to safe, system-controlled values on every
-- insert regardless of what the client sends, mirroring set_request_id().
create or replace function enforce_new_request_defaults()
returns trigger
language plpgsql
as $$
begin
  new.status := 'NEW';
  new.internal_notes := '[]'::jsonb;
  new.activity := jsonb_build_array(jsonb_build_object('text', 'Request created', 'date', now()));
  return new;
end;
$$;

drop trigger if exists trg_enforce_new_request_defaults on project_requests;
create trigger trg_enforce_new_request_defaults
  before insert on project_requests
  for each row
  execute function enforce_new_request_defaults();

-- Same reasoning for contact_messages: force read = false on insert so a
-- visitor can't submit a message pre-marked as already read.
create or replace function enforce_new_message_defaults()
returns trigger
language plpgsql
as $$
begin
  new.read := false;
  return new;
end;
$$;

drop trigger if exists trg_enforce_new_message_defaults on contact_messages;
create trigger trg_enforce_new_message_defaults
  before insert on contact_messages
  for each row
  execute function enforce_new_message_defaults();
