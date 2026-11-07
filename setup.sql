-- Jalankan sekali di Supabase: SQL Editor > New query > paste > Run

create extension if not exists pgcrypto;

create table galleries (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  code text not null unique default encode(gen_random_bytes(9), 'hex'),
  created_at timestamptz default now()
);
create table photos (
  id uuid primary key default gen_random_uuid(),
  gallery_id uuid not null references galleries(id) on delete cascade,
  path text not null,
  name text,
  created_at timestamptz default now()
);
create table picks (
  photo_id uuid primary key references photos(id) on delete cascade,
  gallery_id uuid not null references galleries(id) on delete cascade,
  created_at timestamptz default now()
);

alter table galleries enable row level security;
alter table photos enable row level security;
alter table picks enable row level security;

-- Hanya kamu (akun yang login) yang boleh mengelola data langsung.
create policy "admin galleries" on galleries for all to authenticated using (true) with check (true);
create policy "admin photos" on photos for all to authenticated using (true) with check (true);
create policy "admin picks" on picks for all to authenticated using (true) with check (true);

-- Klien (tanpa login) hanya lewat dua fungsi ini, dan harus membawa kode galeri.
create or replace function get_gallery(p_code text) returns json
language sql security definer set search_path = public as $$
  select json_build_object(
    'title', g.title,
    'photos', coalesce((
      select json_agg(json_build_object(
        'id', p.id, 'path', p.path, 'name', p.name,
        'picked', exists(select 1 from picks k where k.photo_id = p.id)
      ) order by p.created_at)
      from photos p where p.gallery_id = g.id), '[]'::json))
  from galleries g where g.code = p_code;
$$;

create or replace function set_pick(p_code text, p_photo uuid, p_picked boolean) returns void
language plpgsql security definer set search_path = public as $$
declare gid uuid;
begin
  select id into gid from galleries where code = p_code;
  if gid is null or not exists (select 1 from photos where id = p_photo and gallery_id = gid) then
    raise exception 'tidak ditemukan';
  end if;
  if p_picked then
    insert into picks(photo_id, gallery_id) values (p_photo, gid) on conflict do nothing;
  else
    delete from picks where photo_id = p_photo and gallery_id = gid;
  end if;
end $$;

grant execute on function get_gallery(text), set_pick(text, uuid, boolean) to anon, authenticated;

-- Tempat file foto. Bucket publik, tapi tidak bisa dilihat daftarnya dan alamat tiap foto acak.
insert into storage.buckets (id, name, public) values ('photos', 'photos', true) on conflict (id) do nothing;
create policy "admin upload" on storage.objects for insert to authenticated with check (bucket_id = 'photos');
create policy "admin hapus" on storage.objects for delete to authenticated using (bucket_id = 'photos');
