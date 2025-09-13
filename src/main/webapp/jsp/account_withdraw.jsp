<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.Customer" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>お客様脱会手続き</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#dc2626; --primary-600:#b91c1c; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:720px;margin:0 auto;padding:32px 16px 64px}
  h1{font-size:24px;margin:0 0 16px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:20px}
  label{display:block;margin:12px 0 6px;font-weight:600}
  input{width:100%;padding:10px;border:1px solid var(--border);border-radius:8px;font:inherit}
  .muted{color:var(--muted)}
  .alert{padding:10px 12px;border-radius:6px;margin:12px 0}
  .alert.error{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
  .alert.ok{background:#ecfdf5;color:#065f46;border:1px solid #a7f3d0}
  .btn{display:inline-block;padding:10px 16px;border:none;border-radius:8px;background:var(--primary);color:#fff;cursor:pointer}
  .btn:hover{background:var(--primary-600)}
  a.btn-muted{display:inline-block;padding:10px 16px;border:none;border-radius:8px;background:#6b7280;color:#fff;text-decoration:none}
  </style>
  <script>
    function confirmDelete(e){
      var p1 = document.getElementById('password').value;
      var p2 = document.getElementById('passwordConfirm').value;
      if(!p1 || !p2){ alert('パスワードを2回入力してください'); e.preventDefault(); return false; }
      if(p1 !== p2){ alert('パスワードが一致しません'); e.preventDefault(); return false; }
      return confirm('本当にアカウントを削除しますか？この操作は元に戻せません。');
    }
  </script>
</head>
<body>
<div class="container">
  <h1>お客様脱会手続き</h1>

  <% Boolean deleted = (Boolean)request.getAttribute("deleted");
     if (deleted != null && deleted) { %>
    <div class="alert ok">アカウントを削除しました。ご利用ありがとうございました。</div>
    <a class="btn-muted" href="<%= request.getContextPath() %>/">ホームへ</a>
  <% } else { %>
    <% String error = (String)request.getAttribute("error"); if (error != null) { %>
      <div class="alert error"><%= error %></div>
    <% } %>

    <div class="card">
      <%
        Customer c = (Customer)request.getAttribute("customer");
        if (c == null) {
      %>
        <div class="alert error">お客様情報が取得できませんでした。</div>
      <%
        } else {
      %>
        <div class="row"><label>お客様ID</label><div class="muted"><%= c.getId() %></div></div>
        <div class="row"><label>お名前</label><div class="muted"><%= c.getName() %></div></div>
        <div class="row"><label>住所</label><div class="muted"><%= c.getAddress() %></div></div>
        <div class="row"><label>電話番号</label><div class="muted"><%= c.getPhone() %></div></div>
        <div class="row"><label>e-mail</label><div class="muted"><%= c.getEmail() %></div></div>

        <form method="post" action="<%= request.getContextPath() %>/account/withdraw" onsubmit="confirmDelete(event)">
          <label for="password">パスワード</label>
          <input id="password" name="password" type="password" autocomplete="current-password">
          <label for="passwordConfirm">パスワード（確認）</label>
          <input id="passwordConfirm" name="passwordConfirm" type="password" autocomplete="current-password">
          <div style="margin-top:16px">
            <button type="submit" class="btn">アカウントを削除する</button>
            <a class="btn-muted" href="<%= request.getContextPath() %>/reservations">戻る</a>
          </div>
        </form>
      <%
        }
      %>
    </div>
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
