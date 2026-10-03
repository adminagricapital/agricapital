
DROP POLICY IF EXISTS "Anyone can submit news" ON public.news_submissions;
CREATE POLICY "Anyone can submit news" ON public.news_submissions FOR INSERT TO anon, authenticated
WITH CHECK (length(btrim(author_name)) BETWEEN 1 AND 200 AND author_email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$' AND length(author_email) <= 255
  AND length(btrim(title)) BETWEEN 1 AND 300 AND length(btrim(content)) BETWEEN 1 AND 20000
  AND status = 'pending' AND reviewed_by IS NULL AND reviewed_at IS NULL AND published_news_id IS NULL AND review_notes IS NULL);

DROP POLICY IF EXISTS "Anyone can leave contact via chatbot" ON public.visitor_contacts;
CREATE POLICY "Anyone can leave contact via chatbot" ON public.visitor_contacts FOR INSERT TO anon, authenticated
WITH CHECK (length(btrim(session_id)) BETWEEN 1 AND 200
  AND (email IS NULL OR (length(email) <= 255 AND email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'))
  AND (phone IS NULL OR length(phone) <= 40)
  AND (first_name IS NULL OR length(first_name) <= 120) AND (last_name IS NULL OR length(last_name) <= 120));

DROP POLICY IF EXISTS "Anyone can submit a partnership request" ON public.partnership_requests;
CREATE POLICY "Anyone can submit a partnership request" ON public.partnership_requests FOR INSERT TO anon, authenticated
WITH CHECK (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$' AND length(email) <= 255
  AND length(btrim(request_type)) BETWEEN 1 AND 100 AND length(btrim(partner_type)) BETWEEN 1 AND 100
  AND (message IS NULL OR length(message) <= 10000) AND status = 'pending' AND notes IS NULL);

DROP POLICY IF EXISTS "Anyone can subscribe" ON public.newsletter_subscribers;
CREATE POLICY "Anyone can subscribe" ON public.newsletter_subscribers FOR INSERT TO anon, authenticated
WITH CHECK (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$' AND length(email) <= 255 AND is_active = true AND unsubscribed_at IS NULL);

DROP POLICY IF EXISTS "Anyone can record a page visit" ON public.page_visits;
CREATE POLICY "Anyone can record a page visit" ON public.page_visits FOR INSERT TO anon, authenticated
WITH CHECK (length(page_path) BETWEEN 1 AND 2048 AND length(visitor_id) BETWEEN 1 AND 200
  AND (user_agent IS NULL OR length(user_agent) <= 1024) AND (referrer IS NULL OR length(referrer) <= 2048));

DROP POLICY IF EXISTS "Anyone can submit a testimonial" ON public.testimonials;
CREATE POLICY "Anyone can submit a testimonial" ON public.testimonials FOR INSERT TO anon, authenticated
WITH CHECK (approved = false AND length(btrim(first_name)) BETWEEN 1 AND 120 AND length(btrim(last_name)) BETWEEN 1 AND 120
  AND length(btrim(testimonial)) BETWEEN 1 AND 5000 AND (email IS NULL OR length(email) <= 255));

DROP POLICY IF EXISTS "Anyone can send a contact message" ON public.contact_messages;
CREATE POLICY "Anyone can send a contact message" ON public.contact_messages FOR INSERT TO anon, authenticated
WITH CHECK (length(btrim(name)) BETWEEN 1 AND 200 AND email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$' AND length(email) <= 255
  AND length(btrim(message)) BETWEEN 1 AND 10000 AND status = 'new' AND admin_reply IS NULL AND read_at IS NULL AND replied_at IS NULL);
