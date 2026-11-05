-- VAVA anonymous feedback inbox.
-- Run this once in Supabase Dashboard > SQL Editor.
-- Feedback is submitted without authentication. Only the VAVA team should review
-- entries through the Supabase dashboard; public clients cannot read submissions.

create table if not exists public.feedback (
  id uuid primary key default gen_random_uuid(),
  category text not null check (category in ('bug', 'idea', 'comment', 'other')),
  message text not null check (char_length(btrim(message)) between 5 and 4000),
  contact_email text null check (
    contact_email is null or
    (char_length(contact_email) <= 254 and contact_email ~* '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$')
  ),
  created_at timestamptz not null default now()
);

alter table public.feedback enable row level security;

revoke all on table public.feedback from anon, authenticated;
grant insert on table public.feedback to anon, authenticated;

drop policy if exists "Anyone can submit feedback" on public.feedback;
create policy "Anyone can submit feedback"
  on public.feedback
  for insert
  to anon, authenticated
  with check (
    category in ('bug', 'idea', 'comment', 'other')
    and char_length(btrim(message)) between 5 and 4000
    and (
      contact_email is null or
      (char_length(contact_email) <= 254 and contact_email ~* '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$')
    )
  );

-- There is intentionally no SELECT policy and no public SELECT grant.
-- Review submissions in Supabase Dashboard > Table Editor > feedback.
