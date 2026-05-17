-- ══════════════════════════════════════════════════════════
--  MEDROUNDAPP — Supabase Setup
--  Execute no: Supabase Dashboard → SQL Editor → New query
-- ══════════════════════════════════════════════════════════

-- 1. Tabela principal de dados
create table if not exists medrounddata (
  id         text        primary key default 'main',
  data       jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- 2. Trigger: atualiza updated_at automaticamente
create or replace function update_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists medrounddata_updated_at on medrounddata;
create trigger medrounddata_updated_at
  before update on medrounddata
  for each row execute function update_updated_at();

-- 3. Inserir linha inicial (necessário para upsert funcionar)
insert into medrounddata (id, data)
values ('main', '{"cmm":[],"cmf1":[],"cmf2":[]}'::jsonb)
on conflict (id) do nothing;

-- 4. Row Level Security (RLS)
alter table medrounddata enable row level security;

-- Política: leitura anônima permitida
create policy "Allow anonymous read"
  on medrounddata for select
  using (true);

-- Política: escrita anônima permitida (ajuste para auth se necessário)
create policy "Allow anonymous write"
  on medrounddata for all
  using (true)
  with check (true);

-- 5. Realtime: habilitar para sincronização em tempo real
alter publication supabase_realtime add table medrounddata;

-- ══════════════════════════════════════════════════════════
--  APÓS EXECUTAR:
--  1. Copie a URL do projeto: Settings → API → Project URL
--  2. Copie a anon key:       Settings → API → anon public
--  3. Cole no app: ícone ☁️ no header → Configurar Nuvem
-- ══════════════════════════════════════════════════════════
