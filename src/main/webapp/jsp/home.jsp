<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ホーム</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --primary-600:#1d4ed8; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:720px;margin:0 auto;padding:32px 16px 64px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:20px;margin:16px 0}
  h1{font-size:24px;margin:0 0 12px}
  p.muted{color:var(--muted);margin:0 0 20px}
  .links{display:grid;grid-template-columns:1fr;gap:12px;margin-top:8px}
  .link-btn{display:block;text-decoration:none;padding:12px 14px;border-radius:8px;border:1px solid var(--border);background:#fff;color:var(--primary);font-weight:600;text-align:center}
  .link-btn:hover{background:#f3f6ff;border-color:#c7d2fe}
  </style>
  </head>
<body>
<div class="container">
  <h1>Italian へようこそ</h1>
  <p class="muted">以下のメニューからお選びください。</p>

  <div class="card">
    <div class="links">
      <a class="link-btn" href="<%= request.getContextPath() %>/menu">メニュー一覧</a>
      <a class="link-btn" href="<%= request.getContextPath() %>/login">ログイン</a>
      <a class="link-btn" href="<%= request.getContextPath() %>/register">新規お客様登録</a>
      <a class="link-btn" href="<%= request.getContextPath() %>/admin/login">管理者ログイン</a>
      <a class="link-btn" href="https://github.com/MrYamadaJp/italian" target="_blank" rel="noopener noreferrer">GitHub（プロジェクト）</a>
    </div>
  </div>

  </div>
</body>
</html>

