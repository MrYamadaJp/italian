<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>管理者ログイン</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --primary-600:#1d4ed8; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:960px;margin:0 auto;padding:24px 16px 48px}
  .top-nav{background:var(--surface);border-bottom:1px solid var(--border);padding:12px 16px;margin:-24px -16px 24px}
  .top-nav a{margin-right:12px;color:var(--primary);text-decoration:none} .top-nav a:hover{text-decoration:underline}
  h1{font-size:24px;margin:0 0 16px}
  .alert{padding:10px 12px;border-radius:6px;margin:12px 0} .alert.error{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:8px;padding:16px;margin:12px 0}
  button{display:inline-block;padding:8px 14px;border:none;border-radius:6px;background:var(--primary);color:#fff;cursor:pointer} button:hover{background:var(--primary-600)}
  </style>
</head>
<body>
<div class="container">
  <div class="top-nav">
    <a href="<%= request.getContextPath() %>/menu">メニュー</a>
  </div>

  <h1>管理者ログイン</h1>
  <% String errorKey = (String)request.getAttribute("errorKey"); if (errorKey != null) {
       String msg = null;
       if ("INVALID_ADMIN_LOGIN".equals(errorKey)) msg = "ユーザ名またはパスワードが違います";
  %>
  <div class="alert error"><%= msg %></div>
  <% } %>
  <div class="card">
    <form method="post" action="<%= request.getContextPath() %>/admin/login">
      <label>ユーザ名
        <input type="text" name="username" required>
      </label>
      <label>パスワード
        <input type="password" name="password" required>
      </label>
      <button type="submit">ログイン</button>
    </form>
  </div>
  <p class="muted"><!-- 初期管理者: admin / admin1234 --></p>
</div>
</body>
</html>
