# Task 001 — Bootstrap the commercial image MVP inside MakerKit

Inspect the existing repository first. Preserve MakerKit's conventions and packages.

## Objective
Deliver a working vertical slice:

Upload image -> choose Amazon/Studio/Lifestyle -> reserve credits -> create job -> call GPT-Image-2 in a background task -> store result -> consume/release credits -> show result in gallery -> collect feedback.

## Required work

### 1. Inspect MakerKit
- Identify exact MakerKit version and route structure.
- Identify account table, billing package, admin extension pattern and storage helpers.
- Reconcile the draft migration with the installed schema before applying it.

### 2. Database
Implement tables equivalent to:
- catalog_projects
- catalog_assets
- generation_jobs
- generation_attempts
- credit_transactions
- credit_reservations
- generation_cost_events
- generation_feedback

Add indexes, constraints, timestamps and RLS.

### 3. Storage
Create/use a private bucket for product images.
Store:
- originals/{accountId}/{assetId}/source
- generated/{accountId}/{assetId}/result
- previews/{accountId}/{assetId}/preview

Provide signed URLs to the browser.

### 4. Image provider abstraction
Implement the `ImageProvider` contract.
Implement OpenAI provider with model `gpt-image-2` via the official OpenAI SDK image-edit endpoint.
Keep the model configurable by environment variable with `gpt-image-2` as default.

### 5. Prompt presets
Create versioned prompts:
- amazon-v1
- studio-v1
- lifestyle-v1

Do not expose free-form prompting in the MVP.

### 6. Credits and billing
Use MakerKit's existing billing abstraction + Stripe.
Start with one-off credit packs.
Implement append-only credit ledger and reserve/consume/release semantics.
Suggested initial debit:
- Amazon 1 credit
- Studio 2 credits
- Lifestyle 3 credits

### 7. Customer UI
Add customer pages following MakerKit navigation conventions:
- Dashboard
- Images
- Generate
- Projects
- Billing

Image detail must show original + generated derivatives and feedback actions.

### 8. Admin
Extend MakerKit admin with:
- Generations
- Images
- Feedback
- API Costs

Generation detail: original/result, mode, provider/model, prompt version, duration, cost, status and user feedback.

### 9. Job execution
Do not keep the OpenAI generation call inside an ordinary request.
Create a `GenerationQueue` interface.
Use the simplest production-suitable adapter compatible with this repository; prefer Trigger.dev if already present or straightforward to add.

### 10. Tests
Add tests for:
- credit reservation -> consume
- credit reservation -> release after failed job
- illegal job state transitions
- account isolation
- generation preset selection

## Definition of done
- Local MakerKit app boots.
- User can sign in, upload one image and see it in private gallery.
- A test credit grant enables generation.
- All 3 modes create jobs.
- At least one mode successfully edits an uploaded image with GPT-Image-2 using a real API key.
- Result is copied into private application storage.
- Job and cost metadata are persisted.
- Failed job does not permanently consume credits.
- Admin can inspect the generation.
- Typecheck, lint and tests pass.

After completion, report:
1. files changed
2. migrations added
3. environment variables required
4. commands to run locally
5. known limitations
6. recommended Task 002
