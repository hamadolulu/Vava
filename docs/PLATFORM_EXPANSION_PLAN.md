# VAVA Platform Expansion — Stage 1 Baseline

## Scope

This document records the repository state before platform work. This is an inspection and planning change only: it does not replace or edit the existing editor, add marketplace behavior, or claim that payment, plugin execution, or review workflows are implemented.

## Existing application

- `index.html` is the published entry page. It embeds `index.html.html` in an iframe and provides the branded VAVA contact form, which opens a prefilled public GitHub issue.
- `index.html.html` currently contains a short `sendFeedback()` helper fragment. It does not contain a complete HTML document or the editor implementation in the repository version inspected. The helper also references `setStatus()`, which is not defined in that file.
- `READme.md` describes VAVA as a browser-based design editor and documents Supabase setup for accounts, design saving, gallery, and sharing. It instructs operators to apply `supabase/schema.sql` and configure Supabase Auth.
- `supabase/schema.sql` defines the `designs` table, owner/public row-level security policies, and a share lookup function. `supabase/feedback.sql` defines anonymous feedback submission with no public read policy.
- `.github/ISSUE_TEMPLATE/feedback.yml` defines the public feedback issue form.

## Repository and validation baseline

The project is a small, static HTML application with Supabase SQL setup files. The repository has no package manifest, framework/build configuration, automated test suite, or CI workflow in the inspected tree. No automated test command is currently available from the repository documentation.

**Important editor-protection finding:** the inspected `index.html.html` is only a feedback-helper fragment, not a working editor page. This conflicts with the README's description and with the requirement to preserve the editor. Do not overwrite that file or treat the editor as validated. Before adding an editor integration or claiming its features are preserved, recover/locate the actual editor implementation and establish a baseline in a browser.

## Staged implementation plan

1. **Stage 1 — Inspect and document (this change):** record the repository baseline, gaps, and safety gates. No existing application files changed.
2. **Stage 2 — Marketplace interface:** add a separately scoped marketplace surface and sample/catalog presentation; keep it isolated from the editor until the editor source is available.
3. **Stage 3 — Developer portal:** design developer registration and plugin-management flows. Do not treat client-side UI as authentication or authorization.
4. **Stage 4 — Agreements:** define versioned agreement text and acceptance records with server/database-enforced identity, version, and timestamp.
5. **Stage 5 — Submission and review:** add submission versions, review statuses, reviewer decisions, rejection explanations, appeals, and suspension controls. Require review before listing.
6. **Stage 6 — Purchases and payouts:** before implementation, research current payment-provider capabilities and platform-specific purchasing rules. Use server-side payment verification, explicit purchase confirmation, idempotent transaction records, and no unlock on failed/cancelled payment. Never store raw card credentials. Preserve the stated 0% VAVA commission intent while accounting for provider fees, taxes, refunds, chargebacks, and required deductions. No subscriptions.
7. **Stage 7 — Ad-free policy:** prohibit ads in official VAVA experiences and prevent plugin advertising through enforceable capability/policy controls, not only descriptive UI text.
8. **Stage 8 — Verification:** test existing editor workflows after the editor source is recovered, plus marketplace/developer flows, authorization boundaries, package validation, payment failure cases, and ad-free behavior.

## Safety gates before production

- Identify and verify the actual editor source and working save/export/template/integration paths before modifying or embedding any editor code.
- Treat marketplace, developer, moderation, payment, and payout operations as trusted server-side responsibilities. The current static page and browser-exposed Supabase setup alone do not provide a payment backend or plugin sandbox.
- Define a restricted plugin API and package validation/isolation model before enabling plugin execution; do not grant unrestricted access to user files or application data.
- Do not advertise purchases, payouts, approval, or secure plugin isolation as available until their backend and operational controls are implemented and tested.
- Review applicable legal, privacy, tax, consumer, payment-provider, and platform-specific requirements before production launch.

## Stage 1 change record

- Added this baseline document only.
- Existing editor and application files were not modified.
- Tests: no automated test runner or project test command is present in the inspected repository. No application behavior was changed, so runtime tests were not run.
