-- إنشاء جدول المشتركين
CREATE TABLE IF NOT EXISTS subscribers (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL,
  city TEXT DEFAULT '',
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

-- إنشاء جدول المديرين
CREATE TABLE IF NOT EXISTS admins (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  name TEXT DEFAULT 'مدير النظام',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- إضافة حساب المدير الافتراضي
INSERT INTO admins (email, password, name)
VALUES ('odayalsalh1@gmail.com', 'oday2001', 'مدير النظام')
ON CONFLICT (email) DO NOTHING;

-- فتح الوصول (تطبيق إداري)
ALTER TABLE subscribers DISABLE ROW LEVEL SECURITY;
ALTER TABLE payments DISABLE ROW LEVEL SECURITY;
ALTER TABLE admins DISABLE ROW LEVEL SECURITY;

GRANT ALL ON subscribers TO anon, authenticated, service_role;
GRANT ALL ON payments TO anon, authenticated, service_role;
GRANT ALL ON admins TO anon, authenticated, service_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;