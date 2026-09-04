# Architecture

```text
Browser / MakerKit UI
        |
        v
Next.js on Vercel
        |
  +-----+---------------------+
  |                           |
  v                           v
Supabase                    MakerKit Billing
Auth/Postgres/Storage          | Stripe
  |
  v
Generation Service
  |
  v
GenerationQueue
  |
  v
Worker / Trigger.dev
  |
  v
ImageProvider
  |
  v
OpenAI GPT-Image-2
  |
  v
copy result to private Supabase Storage
  |
  v
persist result + costs + feedback
```

## Core lineage

```text
catalog_asset(original)
    -> generation_job
        -> generation_attempt
            -> catalog_asset(generated)
            -> generation_cost_event
            -> generation_feedback
```

## Future provider expansion

```text
ImageProvider
  |- OpenAIImageProvider   [MVP]
  |- BriaProvider          [later]
  |- PhotoRoomProvider     [later]
  `- FalProvider           [later]
```
