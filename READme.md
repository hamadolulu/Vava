# VAVA

Creativity Without Limits — a browser-based design editor.

## Supabase setup

The editor can run locally without Supabase, but online accounts, saving, the public gallery, and sharing need a database schema and Supabase Auth configuration.

1. Open the Supabase project associated with the URL configured in `index.html.html`.
2. In **SQL Editor**, run [`supabase/schema.sql`](supabase/schema.sql).
3. In **Authentication → URL Configuration**, set the Site URL and add the published VAVA site URL to the redirect URLs. For local testing, add the exact local development URL you use.
4. In **Authentication → Providers**, enable Email and choose whether email confirmation should be required.
5. Serve the page from a web server or GitHub Pages rather than opening it as a `file://` URL. Use HTTPS for clipboard support and reliable authentication redirects.
6. Reload the page, create an account, and test with a private design first. Use Unlisted or Public only when you intend others to view the design.

The schema enables owner-only design management with Row Level Security. Public designs are readable in the gallery, while unlisted designs are only returned through the share-token function. Do not put a Supabase `service_role` or secret key in this HTML file.

## App limitations

The **Send Feedback** control does not send anything until a real feedback destination/service is connected. The browser app also cannot confirm that project settings, email delivery, domain redirects, or network access are configured correctly; test those in your own Supabase project and browser.
