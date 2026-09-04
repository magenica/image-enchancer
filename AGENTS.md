# AGENTS.md — Catalog Photo MVP

## Product goal
Build a fast commercial validation MVP for e-commerce product-photo enhancement.

A customer uploads a product photo and creates one of three outputs:
1. Amazon Clean
2. Studio
3. Lifestyle

The first provider is OpenAI GPT-Image-2. Provider-specific code must stay behind an abstraction so BRIA, PhotoRoom and fal.ai can be added later.

## Non-negotiable architecture rules
- Use the existing licensed MakerKit Next.js + Supabase Turbo conventions. Do not rewrite MakerKit auth, billing, navigation, RLS or admin foundations.
- Use `account_id`, not `user_id`, in product tables unless the installed MakerKit version requires otherwise.
- Original images are immutable.
- Uploaded and generated images live in a private storage bucket.
- Never persist temporary provider URLs as the permanent asset location.
- Every generation stores provider, model, prompt version, pipeline version, status, cost and latency.
- Credits use an append-only ledger. Do not store a mutable `credits_balance` as the source of truth.
- Failed generations release/refund reserved credits.
- Long-running image generation must not block a normal request lifecycle. Use a job abstraction.
- Admin must be able to see original/result side-by-side, job status, feedback and API cost.
- Do not claim a guaranteed ProductLock in the MVP. The UI may say "Designed to preserve product details".

## MVP scope
Customer:
- Sign up / login
- Upload images
- Gallery with originals and generated derivatives
- Generate Amazon / Studio / Lifestyle
- Before/after comparison
- Download / delete
- Credits + Stripe checkout
- 👍 / 👎 feedback with issue reason

Admin:
- Users
- Images
- Generation jobs
- Payments / credits
- API costs
- Feedback

## Out of scope for Task 001
- SAM/BiRefNet segmentation pipeline
- ProductLock computer-vision QA
- PhotoRoom/BRIA/fal providers
- marketplace category compliance engine
- team accounts
- occlusion engine
- bulk processing beyond simple schema readiness

## Engineering requirements
- TypeScript strict mode
- Zod input validation
- Server-side authorization on every mutation
- RLS for customer-owned rows
- Idempotent billing/webhook and job transitions
- Unit tests for credit ledger and generation state transitions
- No secrets committed to git
