<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ユーザー画面</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --primary-600:#1d4ed8; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:720px;margin:0 auto;padding:32px 16px 64px}
  h1{font-size:24px;margin:0 0 12px}
  p.muted{color:var(--muted);margin:0 0 20px}
  .grid{display:grid;grid-template-columns:1fr;gap:12px}
  .btn-link{display:block;text-decoration:none;padding:14px 16px;border-radius:10px;border:1px solid var(--border);background:#fff;color:var(--primary);font-weight:700;text-align:center}
  .btn-link:hover{background:#f3f6ff;border-color:#c7d2fe}
  </style>
</head>
<body>
<div class="container">
  <h1>ユーザー メニュー</h1>
  <p class="muted">ご希望の操作をお選びください。</p>

  <div class="grid">
    <a class="btn-link" href="<%= request.getContextPath() %>/menu">メニュー紹介</a>
    <a class="btn-link" href="<%= request.getContextPath() %>/reservations">ご予約</a>
    <a class="btn-link" href="<%= request.getContextPath() %>/account/edit">お客様情報変更</a>
    <a class="btn-link" href="<%= request.getContextPath() %>/account/withdraw">お客様脱会手続き</a>
    <a class="btn-link" href="<%= request.getContextPath() %>/logout">ログオフ</a>
  </div>

</div>
</body>
</html>
