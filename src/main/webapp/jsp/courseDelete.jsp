<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="beans.Dish,beans.Course" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>コース削除確認</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --danger:#ef4444; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:840px;margin:0 auto;padding:32px 16px 64px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:20px;margin:16px 0}
  .inline{display:flex;gap:8px;align-items:center}
  .muted{color:var(--muted)}
  button{padding:10px 14px;border:none;border-radius:8px;background:var(--danger);color:#fff;cursor:pointer}
  button:hover{background:#b91c1c}
  .btn{display:inline-block;padding:10px 14px;border:1px solid var(--border);border-radius:8px;text-decoration:none;color:var(--primary)}
  .btn-cancel{display:inline-block;padding:10px 14px;border:none;border-radius:8px;text-decoration:none;background:#6b7280;color:#fff}
  .btn-cancel:hover{background:#4b5563}
  table{width:100%;border-collapse:collapse;background:var(--surface)} th,td{padding:8px;border-bottom:1px solid var(--border)} thead th{background:#f3f4f6}
  </style>
  <script>
    function confirmDelete(){
      return confirm('このコースを削除します。よろしいですか？');
    }
  </script>
</head>
<body>
<div class="container">
  <h1>コース削除確認</h1>
  <% Course c = (Course)request.getAttribute("course"); if (c == null) { try { String idp = request.getParameter("id"); if (idp != null && idp.length() > 0) c = new dao.MenuDAO().getCourseById(Integer.parseInt(idp)); } catch (Exception ignore) {} } %>
  <div class="card">
    <p class="muted">以下のコースを削除します。内容をご確認ください。</p>
    <table>
      <tbody>
        <tr><th style="width:160px;text-align:left">ID</th><td><%= c==null?"":c.getId() %></td></tr>
        <tr><th style="text-align:left">コース名</th><td><%= c==null?"":c.getName() %></td></tr>
        <tr><th style="text-align:left">価格</th><td>¥<%= c==null?"":c.getPrice() %></td></tr>
        <tr><th style="text-align:left">オーダー可</th><td><%= (c!=null && c.isActive())?"可":"不可" %></td></tr>
        <tr><th style="text-align:left">コメント</th><td><%= c==null?"":(c.getDescription()==null?"":c.getDescription()) %></td></tr>
      </tbody>
    </table>
  </div>

  <div class="card">
    <h2 style="margin:0 0 12px;font-size:18px">コース構成</h2>
    <%
      List<Integer> selected = (List<Integer>)request.getAttribute("selectedDishIds");
      List<Dish> all = (List<Dish>)request.getAttribute("allDishes");
      if (selected == null || selected.isEmpty() || all == null) {
    %>
      <p class="muted">登録されている料理はありません。</p>
    <% } else { %>
      <ul>
      <% for (Dish d : all) { if (selected.contains(d.getId())) { %>
        <li><%= d.getName() %>（¥<%= d.getPrice() %>）</li>
      <% } } %>
      </ul>
    <% } %>
  </div>

  <form method="post" action="<%= request.getContextPath() %>/admin/menu/maintenance/delete" onsubmit="return confirmDelete()">
    <input type="hidden" name="type" value="course">
    <input type="hidden" name="id" value="<%= c==null?"":c.getId() %>">
    <button type="submit">削除する</button>
    <a class="btn-cancel" href="<%= request.getContextPath() %>/admin/menu/maintenance?section=course">キャンセル</a>
  </form>

</div>
</body>
</html>
