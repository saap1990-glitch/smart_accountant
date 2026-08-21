const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const Database = require('better-sqlite3');
const { v4: uuidv4 } = require('uuid');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'smart_accountant_secret_change_me';

app.use(cors());
app.use(express.json());

// إنشاء قاعدة البيانات
const db = new Database('smart_accountant.db');

db.exec(`
  CREATE TABLE IF NOT EXISTS apps (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS subscriptions (
    id TEXT PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,
    app_id TEXT NOT NULL,
    type TEXT NOT NULL,
    start_date TEXT NOT NULL,
    expiry_date TEXT NOT NULL,
    is_active INTEGER DEFAULT 1,
    revoked INTEGER DEFAULT 0,
    created_at TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS admin_users (
    username TEXT PRIMARY KEY,
    password TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS notifications (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    created_at TEXT NOT NULL
  );
`);

// إدارة الاشتراكات
const AdminUser = db.prepare('SELECT * FROM admin_users WHERE username = ?');
const InsertSubscription = db.prepare(`
  INSERT INTO subscriptions (id, code, app_id, type, start_date, expiry_date, created_at)
  VALUES (?, ?, ?, ?, ?, ?, ?)
`);
const GetSubscriptionByCode = db.prepare('SELECT * FROM subscriptions WHERE code = ?');
const RevokeSubscription = db.prepare('UPDATE subscriptions SET revoked = 1 WHERE code = ?');

// ========== واجهات التطبيق ==========

// تفعيل الاشتراك برمز
app.post('/api/activate', (req, res) => {
  const { code } = req.body;
  if (!code) return res.status(400).json({ error: 'الرمز مطلوب' });

  const sub = GetSubscriptionByCode.get(code);
  if (!sub) return res.status(404).json({ error: 'رمز غير صحيح' });
  if (sub.revoked) return res.status(403).json({ error: 'الرمز مُبطل' });
  if (!sub.is_active) return res.status(403).json({ error: 'الاشتراك غير نشط' });
  if (new Date(sub.expiry_date) < new Date()) return res.status(403).json({ error: 'الاشتراك منتهي' });

  res.json({
    success: true,
    type: sub.type,
    start_date: sub.start_date,
    expiry_date: sub.expiry_date,
  });
});

// التحقق من الاشتراك (للتحقق عند بدء التشغيل)
app.post('/api/verify', (req, res) => {
  const { code } = req.body;
  const sub = GetSubscriptionByCode.get(code);
  if (!sub) return res.status(404).json({ error: 'غير موجود' });
  res.json({
    success: true,
    is_active: sub.is_active === 1 && !sub.revoked && new Date(sub.expiry_date) > new Date(),
    type: sub.type,
    expiry_date: sub.expiry_date,
  });
});

// ========== لوحة تحكم المالك ==========

// تسجيل الدخول للمالك
app.post('/api/admin/login', (req, res) => {
  const { username, password } = req.body;
  const admin = AdminUser.get(username);
  if (!admin || admin.password !== password) {
    return res.status(401).json({ error: 'بيانات دخول غير صحيحة' });
  }
  const token = jwt.sign({ username }, JWT_SECRET, { expiresIn: '7d' });
  res.json({ success: true, token });
});

// التحقق من صلاحية الرمز
function authAdmin(req, res, next) {
  const token = req.headers.authorization?.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'غير مصرح' });
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.admin = decoded;
    next();
  } catch (e) {
    return res.status(401).json({ error: 'جلسة منتهية' });
  }
}

// توليد رمز اشتراك جديد (للمالك)
app.post('/api/admin/generate-code', authAdmin, (req, res) => {
  const { type, duration_days } = req.body;
  const prefix = type === 'semi_annual' ? 'SEMI' : type === 'annual' ? 'ANNUAL' : 'LIFE';
  const code = `${prefix}-${uuidv4().slice(0, 8).toUpperCase()}`;
  const start = new Date();
  const expiry = new Date(start.getTime() + duration_days * 24 * 60 * 60 * 1000);
  const id = uuidv4();
  InsertSubscription.run(id, code, 'default', type, start.toISOString(), expiry.toISOString(), new Date().toISOString());
  res.json({ success: true, code, expiry_date: expiry.toISOString() });
});

// إبطال رمز
app.post('/api/admin/revoke-code', authAdmin, (req, res) => {
  const { code } = req.body;
  RevokeSubscription.run(code);
  res.json({ success: true });
});

// إرسال إشعار (تخزينه لاسترجاعه من التطبيق لاحقًا)
app.post('/api/admin/send-notification', authAdmin, (req, res) => {
  const { title, message } = req.body;
  const id = uuidv4();
  db.prepare('INSERT INTO notifications (id, title, message, created_at) VALUES (?, ?, ?, ?)')
    .run(id, title, message, new Date().toISOString());
  res.json({ success: true });
});

// جلب الإشعارات للتطبيق
app.get('/api/notifications', (req, res) => {
  const notifications = db.prepare('SELECT * FROM notifications ORDER BY created_at DESC LIMIT 50').all();
  res.json({ success: true, notifications });
});

// جلب كل الرموز (للعرض في لوحة التحكم)
app.get('/api/admin/codes', authAdmin, (req, res) => {
  const codes = db.prepare('SELECT * FROM subscriptions ORDER BY created_at DESC').all();
  res.json({ success: true, codes });
});

// ========== تشغيل الخادم ==========
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
