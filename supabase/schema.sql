-- VAVA Supabase schema
-- Run this once in Supabase Dashboard > SQL Editor, then reload the app.
-- This schema uses the public publishable key in the browser with RLS enabled.

create table if not exists public.designs (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'Untitled Design'
    check (char_length(title) between 1 and 120),
  visibility text not null default 'private'
    check (visibility in ('private', 'unlisted', 'public')),
  design_data jsonb not null
    check (
      jsonb_typeof(design_data) = 'object'
      and jsonb_typeof(design_data -> 'objects') = 'array'
    ),
  share_token uuid not null unique default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists designs_owner_updated_idx
  on public.designs (owner_id, updated_at desc);

create index if not exists designs_public_created_idx
  on public.designs (created_at desc)
  where visibility = 'public';

alter table public.designs enable row level security;

-- Owners can manage their own designs. Public designs can be read by everyone.
drop policy if exists "Owners and public can read designs" on public.designs;
create policy "Owners and public can read designs"
  on public.designs
  for select
  to anon, authenticated
  using (owner_id = (select auth.uid()) or visibility = 'public');

drop policy if exists "Owners can create designs" on public.designs;
create policy "Owners can create designs"
  on public.designs
  for insert
  to authenticated
  with check (owner_id = (select auth.uid()));

drop policy if exists "Owners can update designs" on public.designs;
create policy "Owners can update designs"
  on public.designs
  for update
  to authenticated
  using (owner_id = (select auth.uid()))
  with check (owner_id = (select auth.uid()));

drop policy if exists "Owners can delete designs" on public.designs;
create policy "Owners can delete designs"
  on public.designs
  for delete
  to authenticated
  using (owner_id = (select auth.uid()));

-- The browser app calls this function for both unlisted and public share links.
-- It returns only the fields needed to view a shared design.
create or replace function public.get_shared_design(p_token uuid)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'id', d.id,
    'title', d.title,
    'visibility', d.visibility,
    'design_data', d.design_data
  )
  from public.designs as d
  where d.share_token = p_token
    and d.visibility in ('unlisted', 'public')
  limit 1;
$$;

revoke all on function public.get_shared_design(uuid) from public;
grant execute on function public.get_shared_design(uuid) to anon, authenticated;

grant usage on schema public to anon, authenticated;
grant select on public.designs to anon, authenticated;
grant insert, update, delete on public.designs to authenticated;
