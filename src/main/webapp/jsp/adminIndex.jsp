<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>管理者メニュー</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --primary-600:#1d4ed8; --danger:#ef4444; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:720px;margin:0 auto;padding:32px 16px 64px}
  .top-nav{background:var(--surface);border-bottom:1px solid var(--border);padding:12px 16px;margin:-24px -16px 24px}
  .top-nav a{margin-right:12px;color:var(--primary);text-decoration:none} .top-nav a:hover{text-decoration:underline}
  h1{font-size:24px;margin:0 0 16px}
  .grid{display:grid;grid-template-columns:1fr;gap:12px}
  .btn{display:block;text-decoration:none;padding:14px 16px;border-radius:10px;border:1px solid var(--border);background:#fff;color:var(--primary);font-weight:700;text-align:center}
  .btn:hover{background:#f3f6ff;border-color:#c7d2fe}
  .btn-danger{border-color:var(--danger);color:var(--danger)} .btn-danger:hover{background:#fef2f2;border-color:#fecaca}
  </style>
</head>
<body>
<div class="container">
  <div class="top-nav">
    <a href="<%= request.getContextPath() %>/home">ホーム</a>
    <a href="<%= request.getContextPath() %>/menu">公開メニュー</a>
  </div>

  <h1>管理者メニュー</h1>
  <div class="grid">
    <a class="btn" href="<%= request.getContextPath() %>/admin/menu/maintenance">メニューメンテナンス</a>
    <a class="btn btn-danger" href="<%= request.getContextPath() %>/admin/logout">ログオフ</a>
  </div>

</div>
</body>
</html>

