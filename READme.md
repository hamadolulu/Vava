# VAVA

Creativity Without Limits — a browser-based design editor.

## Contact and feedback

The deployed entry page is [`index.html`](index.html). Its **Contact VAVA** button opens an in-app form that accepts comments without a VAVA account. Submissions are stored privately in the Supabase `feedback` table for the project owner to review in **Supabase Dashboard → Table Editor → feedback**. If a visitor supplies an email, it is included so the VAVA team can reply; it is optional.

To enable the contact form, open the Supabase project configured in the app, go to **SQL Editor**, and run [`supabase/feedback.sql`](supabase/feedback.sql) once. Do not add a service-role or secret key to the browser. The form uses the public publishable key with Row Level Security; clients can submit feedback but cannot read submissions.

The form has a basic honeypot, but public anonymous endpoints can receive spam. Add server-side CAPTCHA and rate limiting before promoting it widely. Submissions do not send email notifications; review them in the Supabase dashboard.

## Supabase editor setup

Online editor accounts, design saving, the public gallery, and sharing need the database schema and Supabase Auth configuration:

1. In Supabase **SQL Editor**, run [`supabase/schema.sql`](supabase/schema.sql).
2. In **Authentication → URL Configuration**, set the Site URL and add your published site URL to redirect URLs.
3. In **Authentication → Providers**, enable Email and choose the confirmation policy.
4. Host the site over HTTPS rather than opening it through `file://`.

The SQL schema applies Row Level Security. Never include a Supabase `service_role` or secret key in browser code.
