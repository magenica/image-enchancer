# Catalog Photo MVP — Codex bootstrap

Working scaffold for a MakerKit Next.js + Supabase commercial MVP that turns uploaded product photos into:

- Amazon Clean
- Studio
- Lifestyle

Initial image provider: OpenAI GPT-Image-2.

This bundle is intentionally an **overlay/scaffold**, not a redistribution of MakerKit. Apply it inside a licensed MakerKit Next.js + Supabase Turbo repository.

## Target stack

- MakerKit Next.js + Supabase Turbo
- Vercel
- Supabase Auth / Postgres / private Storage
- MakerKit billing + Stripe
- OpenAI GPT-Image-2
- Background job abstraction (Trigger.dev can be used in the first production deployment)

## Start with Codex

1. Create or open your licensed MakerKit repository.
2. Copy the files from this bundle into the repository root.
3. Open the repository in Codex.
4. Run the task in `.codex/TASK_001_BOOTSTRAP_MVP.md`.
5. Let Codex inspect the actual MakerKit schema and adapt migrations/routes before applying them.

Do not apply the draft SQL blindly: MakerKit schema details can differ by version.
"# image-enchancer" 
