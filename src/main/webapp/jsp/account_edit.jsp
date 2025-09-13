<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.Customer" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>お客様情報変更</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --primary-600:#1d4ed8; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:720px;margin:0 auto;padding:32px 16px 64px}
  h1{font-size:24px;margin:0 0 16px}
  form{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:20px}
  label{display:block;margin:12px 0 6px;font-weight:600}
  input{width:100%;padding:10px;border:1px solid var(--border);border-radius:8px;font:inherit}
  .row{margin-bottom:12px}
  .actions{margin-top:16px}
  .btn{display:inline-block;padding:10px 16px;border:none;border-radius:8px;background:var(--primary);color:#fff;cursor:pointer}
  .btn:hover{background:var(--primary-600)}
  .alert{padding:10px 12px;border-radius:6px;margin:12px 0}
  .alert.error{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
  .alert.ok{background:#ecfdf5;color:#065f46;border:1px solid #a7f3d0}
  .muted{color:var(--muted)}
  </style>
  <script>
    function validateForm(e){
      var p = document.getElementById('password').value;
      var pc = document.getElementById('passwordConfirm').value;
      if((p||pc) && p!==pc){
        alert('パスワードが一致しません');
        e.preventDefault();
        return false;
      }
      return true;
    }
  </script>
</head>
<body>
<div class="container">
  <h1>お客様情報変更</h1>

  <% String error = (String)request.getAttribute("error");
     String success = (String)request.getAttribute("success");
     if (error != null) { %>
     <div class="alert error"><%= error %></div>
  <% } else if (success != null) { %>
     <div class="alert ok"><%= success %></div>
  <% } %>

  <%
    Customer c = (Customer)request.getAttribute("customer");
    if (c == null) {
  %>
    <div class="alert error">お客様情報が取得できませんでした。</div>
  <%
    } else {
  %>
  <form method="post" action="<%= request.getContextPath() %>/account/edit" onsubmit="validateForm(event)">
    <div class="row">
      <label>お客様ID（表示のみ）</label>
      <div class="muted"><%= c.getId() %></div>
    </div>
    <div class="row">
      <label for="name">お名前</label>
      <input id="name" name="name" type="text" value="<%= c.getName() == null ? "" : c.getName() %>" required>
    </div>
    <div class="row">
      <label for="address">住所</label>
      <input id="address" name="address" type="text" value="<%= c.getAddress() == null ? "" : c.getAddress() %>">
    </div>
    <div class="row">
      <label for="phone">電話番号</label>
      <input id="phone" name="phone" type="text" value="<%= c.getPhone() == null ? "" : c.getPhone() %>">
    </div>
    <div class="row">
      <label for="email">e-mail</label>
      <input id="email" name="email" type="email" value="<%= c.getEmail() == null ? "" : c.getEmail() %>" required>
    </div>
    <div class="row">
      <label for="password">パスワード（変更する場合のみ入力）</label>
      <input id="password" name="password" type="password" autocomplete="new-password">
    </div>
    <div class="row">
      <label for="passwordConfirm">パスワード（確認）</label>
      <input id="passwordConfirm" name="passwordConfirm" type="password" autocomplete="new-password">
    </div>
    <div class="actions">
      <button type="submit" class="btn">保存する</button>
      <a class="btn" style="text-decoration:none;background:#6b7280" href="<%= request.getContextPath() %>/reservations">戻る</a>
    </div>
  </form>
  <% } %>

</div>
<script>
  (function(){
    var ctx = '<%= request.getContextPath() %>';
    document.querySelectorAll('a[href$="/reservations"]').forEach(function(a){
      a.setAttribute('href', ctx + '/jsp/userIndex.jsp');
    });
  })();
</script>
</body>
</html>
