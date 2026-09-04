-- DRAFT ONLY.
-- Codex MUST reconcile this migration with the exact MakerKit schema before applying.
-- Assumes public.accounts(id uuid) exists.

create type public.catalog_asset_kind as enum ('original', 'generated');
create type public.generation_mode as enum ('amazon', 'studio', 'lifestyle');
create type public.generation_status as enum ('queued', 'processing', 'completed', 'failed', 'cancelled');
create type public.credit_transaction_type as enum ('purchase', 'generation', 'refund', 'bonus', 'admin_adjustment');

create table public.catalog_projects (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references public.accounts(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.catalog_assets (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references public.accounts(id) on delete cascade,
  project_id uuid references public.catalog_projects(id) on delete set null,
  parent_asset_id uuid references public.catalog_assets(id) on delete set null,
  kind public.catalog_asset_kind not null,
  generation_mode public.generation_mode,
  storage_path text not null,
  preview_path text,
  original_filename text,
  mime_type text not null,
  width int,
  height int,
  size_bytes bigint,
  sha256 text,
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table public.generation_jobs (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references public.accounts(id) on delete cascade,
  source_asset_id uuid not null references public.catalog_assets(id) on delete cascade,
  result_asset_id uuid references public.catalog_assets(id) on delete set null,
  mode public.generation_mode not null,
  status public.generation_status not null default 'queued',
  provider text not null default 'openai',
  model text not null default 'gpt-image-2',
  prompt_version text not null,
  pipeline_version text not null default 'mvp-v1',
  credits_reserved int not null default 0,
  credits_consumed int not null default 0,
  estimated_cost_usd numeric(12,6),
  actual_cost_usd numeric(12,6),
  error_code text,
  error_message text,
  created_at timestamptz not null default now(),
  started_at timestamptz,
  completed_at timestamptz
);

create table public.generation_attempts (
  id uuid primary key default gen_random_uuid(),
  job_id uuid not null references public.generation_jobs(id) on delete cascade,
  attempt_no int not null,
  provider text not null,
  model text not null,
  provider_request_id text,
  latency_ms int,
  status public.generation_status not null,
  error_code text,
  created_at timestamptz not null default now(),
  unique(job_id, attempt_no)
);

create table public.credit_transactions (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references public.accounts(id) on delete cascade,
  type public.credit_transaction_type not null,
  credits int not null check (credits <> 0),
  job_id uuid references public.generation_jobs(id) on delete set null,
  external_payment_id text,
  description text,
  created_at timestamptz not null default now()
);

create table public.credit_reservations (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references public.accounts(id) on delete cascade,
  job_id uuid not null unique references public.generation_jobs(id) on delete cascade,
  credits int not null check (credits > 0),
  status text not null check (status in ('reserved','consumed','released')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.generation_cost_events (
  id uuid primary key default gen_random_uuid(),
  job_id uuid not null references public.generation_jobs(id) on delete cascade,
  attempt_id uuid references public.generation_attempts(id) on delete set null,
  provider text not null,
  model text not null,
  operation text not null,
  cost_usd numeric(12,6) not null check (cost_usd >= 0),
  estimated boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.generation_feedback (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references public.accounts(id) on delete cascade,
  job_id uuid not null references public.generation_jobs(id) on delete cascade,
  is_positive boolean not null,
  issue_codes text[] not null default '{}',
  comment text,
  created_at timestamptz not null default now(),
  unique(account_id, job_id)
);

create index catalog_assets_account_idx on public.catalog_assets(account_id, created_at desc);
create index generation_jobs_account_idx on public.generation_jobs(account_id, created_at desc);
create index generation_jobs_status_idx on public.generation_jobs(status, created_at);
create index credit_transactions_account_idx on public.credit_transactions(account_id, created_at);
create index generation_cost_job_idx on public.generation_cost_events(job_id);

-- RLS policies intentionally omitted from this draft.
-- Codex must implement them using MakerKit's account-membership helpers/policies.
