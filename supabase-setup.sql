-- إنشاء جدول المشتركين
CREATE TABLE IF NOT EXISTS subscribers (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL,
  subscription_size TEXT NOT NULL,
  amount_due TEXT NOT NULL DEFAULT '0',
  custom_fields JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- إنشاء جدول المدفوعات
CREATE TABLE IF NOT EXISTS payments (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  subscriber_id BIGINT REFERENCES subscribers(id) ON DELETE CASCADE,
  amount NUMERIC NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- فتح الوصول للجميع (تطبيق إداري)
ALTER TABLE subscribers DISABLE ROW LEVEL SECURITY;
ALTER TABLE payments DISABLE ROW LEVEL SECURITY;

-- للسماح بالوصول عبر Service Role Key
GRANT ALL ON subscribers TO anon, authenticated, service_role;
GRANT ALL ON payments TO anon, authenticated, service_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;