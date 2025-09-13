<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="beans.Category,beans.Dish,beans.Course" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>コース内容編集</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:960px;margin:0 auto;padding:24px 16px 64px}
  .top-nav{background:var(--surface);border-bottom:1px solid var(--border);padding:12px 16px;margin:-24px -16px 24px}
  .top-nav a{margin-right:12px;color:var(--primary);text-decoration:none} .top-nav a:hover{text-decoration:underline}
  h1{font-size:24px;margin:0 0 16px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:8px;padding:16px;margin:12px 0}
  .muted{color:var(--muted)}
  </style>
</head>
<body>
<div class="container">
  <div class="top-nav">
    <a href="<%= request.getContextPath() %>/admin/menu/maintenance">メンテナンスへ戻る</a>
  </div>

  <h1>コース内容編集</h1>
  <% Course course = (Course)request.getAttribute("course"); %>
  <p class="muted">コース: <strong><%= course == null ? "" : course.getName() %></strong></p>

  <form method="post" action="<%= request.getContextPath() %>/admin/menu/maintenance/course">
    <input type="hidden" name="id" value="<%= course == null ? "" : course.getId() %>">
    <% List<Category> categories = (List<Category>)request.getAttribute("categories");
       List<Dish> allDishes = (List<Dish>)request.getAttribute("allDishes");
       List<Integer> selected = (List<Integer>)request.getAttribute("selectedDishIds");
       if (categories != null) {
         for (Category cat : categories) { %>
      <div class="card">
        <h3 style="margin:0 0 8px"><%= cat.getName() %></h3>
        <% for (Dish d : allDishes) {
             if (d.getCategoryId() == cat.getId() && d.isActive()) { %>
           <label style="display:block;margin:6px 0">
             <input type="checkbox" name="dishIds" value="<%= d.getId() %>" <%= (selected!=null && selected.contains(d.getId()))?"checked":"" %>>
             <%= d.getName() %>（¥<%= d.getPrice() %>）
           </label>
        <%   }
           } %>
      </div>
    <% } } %>
    <button type="submit">保存</button>
  </form>

</div>
</body>
</html>
