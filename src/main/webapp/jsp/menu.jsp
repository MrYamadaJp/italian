<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="beans.Category,beans.Dish,beans.Course" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>メニュー一覧</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --primary-600:#1d4ed8; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:960px;margin:0 auto;padding:24px 16px 48px}
  .top-nav{background:var(--surface);border-bottom:1px solid var(--border);padding:12px 16px;margin:-24px -16px 24px}
  .top-nav a{margin-right:12px;color:var(--primary);text-decoration:none} .top-nav a:hover{text-decoration:underline}
  h1{font-size:24px;margin:0 0 16px} h2{font-size:20px;margin:24px 0 12px}
  table{width:100%;border-collapse:collapse;background:var(--surface)} th,td{padding:10px 12px;border-bottom:1px solid var(--border);text-align:left} thead th{background:#f3f4f6} tr:nth-child(even) td{background:#fafafa}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:8px;padding:16px;margin:12px 0}
  .muted{color:var(--muted)}
  </style>
</head>
<body>
<div class="container">
  <div class="top-nav">
    <a href="<%= request.getContextPath() %>/">ホーム</a>
  </div>

  <h1>メニュー一覧</h1>

  <!-- 上: コース一覧 -->
  <h2>コース</h2>
  <div class="card">
    <ul>
      <%
        List<Course> courses = (List<Course>) request.getAttribute("courses");
        if (courses != null) {
          for (Course c : courses) {
      %>
        <li>
          <strong><%= c.getName() %></strong>（￥<%= c.getPrice() %>） -
          <span class="muted"><%= c.getDescription() %></span>
        </li>
      <%
          }
        }
      %>
    </ul>
  </div>

  <!-- 下: 一品料理（カテゴリごと） -->
  <h2>一品料理（カテゴリ別）</h2>
  <%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    Map<Integer, List<Dish>> dishesByCategory = (Map<Integer, List<Dish>>) request.getAttribute("dishesByCategory");
    if (categories != null) {
      for (Category cat : categories) {
        List<Dish> dishes = dishesByCategory != null ? dishesByCategory.get(cat.getId()) : null;
  %>
    <div class="card">
      <h3 style="margin:0 0 8px;font-size:18px;"><%= cat.getName() %></h3>
      <%
        if (dishes != null && !dishes.isEmpty()) {
      %>
      <table>
        <thead>
          <tr><th style="width:25%">料理名</th><th>説明</th><th style="width:15%">価格</th></tr>
        </thead>
        <tbody>
        <%
          for (Dish d : dishes) {
        %>
          <tr>
            <td><%= d.getName() %></td>
            <td><%= d.getDescription() %></td>
            <td>￥<%= d.getPrice() %></td>
          </tr>
        <%
          }
        %>
        </tbody>
      </table>
      <%
        } else {
      %>
        <p class="muted" style="margin:8px 0 0;">現在、該当の料理はありません。</p>
      <%
        }
      %>
    </div>
  <%
      }
    }
  %>

</div>
</body>
</html>
