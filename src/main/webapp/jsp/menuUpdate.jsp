<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="beans.Category,beans.Dish,beans.Course" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>更新</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:720px;margin:0 auto;padding:32px 16px 64px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:20px;margin:16px 0}
  .inline{display:flex;gap:8px;align-items:center;justify-content:flex-start}
  input[type=text], input[type=number], textarea, select{width:100%;padding:10px;border:1px solid var(--border);border-radius:8px;font:inherit}
  input[type=checkbox]{width:auto;margin:0}
  label{display:block;margin:10px 0 6px;font-weight:600}
  button{padding:10px 14px;border:none;border-radius:8px;background:#2563eb;color:#fff;cursor:pointer}
  button:hover{background:#1d4ed8}
  </style>
</head>
<body>
<div class="container">
  <h1>更新</h1>
  <% String type = (String)request.getAttribute("type"); %>
  <div class="card">
    <form method="post" action="<%= request.getContextPath() %>/admin/menu/maintenance/update">
      <input type="hidden" name="type" value="<%= type %>">
      <% if ("dish".equals(type)) { Dish d = (Dish)request.getAttribute("dish"); List<Category> categories=(List<Category>)request.getAttribute("categories"); %>
        <input type="hidden" name="id" value="<%= d.getId() %>">
        <label>カテゴリ</label>
        <select name="categoryId" required>
          <% if (categories != null) { for (Category c : categories) { %>
            <option value="<%= c.getId() %>" <%= d.getCategoryId()==c.getId()?"selected":"" %>><%= c.getName() %></option>
          <% } } %>
        </select>
        <label>料理名</label>
        <input type="text" name="name" value="<%= d.getName() %>" required>
        <label>価格</label>
        <input type="number" name="price" value="<%= d.getPrice() %>" required>
        <label>説明</label>
        <textarea name="description"><%= d.getDescription()==null?"":d.getDescription() %></textarea>
        <label class="inline"><input type="checkbox" name="active" <%= d.isActive()?"checked":"" %>> 有効</label>
      <% } else if ("course".equals(type)) { Course c = (Course)request.getAttribute("course"); %>
        <input type="hidden" name="id" value="<%= c.getId() %>">
        <label>コース名</label>
        <input type="text" name="name" value="<%= c.getName() %>" required>
        <label>価格</label>
        <input type="number" name="price" value="<%= c.getPrice() %>" required>
        <label>説明</label>
        <input type="text" name="description" value="<%= c.getDescription()==null?"":c.getDescription() %>">
        <label class="inline"><input type="checkbox" name="active" <%= c.isActive()?"checked":"" %>> 有効</label>
      <% } %>
      <div class="inline" style="margin-top:12px">
        <button type="submit">保存</button>
        <a class="inline" href="<%= request.getContextPath() %>/admin/menu/maintenance" style="text-decoration:none;padding:10px 14px;border:1px solid var(--border);border-radius:8px;color:#2563eb">キャンセル</a>
      </div>
    </form>
  </div>
</div>
</body>
</html>
