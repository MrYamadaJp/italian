<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.Dish,beans.Course,beans.Category" %>
<%@ page import="dao.MenuDAO" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>削除確認</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --danger:#ef4444; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:720px;margin:0 auto;padding:32px 16px 64px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:20px;margin:16px 0}
  .inline{display:flex;gap:8px;align-items:center}
  .muted{color:var(--muted)}
  button{padding:10px 14px;border:none;border-radius:8px;background:var(--danger);color:#fff;cursor:pointer}
  button:hover{background:#b91c1c}
  .btn{display:inline-block;padding:10px 14px;border:1px solid var(--border);border-radius:8px;text-decoration:none;color:var(--primary)}
  .btn-cancel{display:inline-block;padding:10px 14px;border:none;border-radius:8px;text-decoration:none;background:#6b7280;color:#fff}
  .btn-cancel:hover{background:#4b5563}
  </style>
  <script>
    function confirmDelete(){ return confirm('削除します。よろしいですか？'); }
  </script>
  </head>
<body>
<div class="container">
  <h1>削除確認</h1>
  <% 
     String type = (String)request.getAttribute("type");
     if (type == null || type.isEmpty()) { type = request.getParameter("type"); }
  %>
  <div class="card">
    <% if ("dish".equals(type)) { 
         Dish d = (Dish)request.getAttribute("dish"); 
         if (d == null) { try { String idp = request.getParameter("id"); if (idp != null && idp.length() > 0) { d = new MenuDAO().getDishById(Integer.parseInt(idp)); request.setAttribute("dish", d); } } catch (Exception ignore) {} } 
    %>
      <p class="muted">以下の料理を削除します。よろしいですか？</p>
      <ul>
        <li>ID: <%= d==null?"":d.getId() %></li>
        <li>料理名: <%= d==null?"":d.getName() %></li>
        <li>価格: ¥<%= d==null?"":d.getPrice() %></li>
        <li>説明: <%= d==null?"":(d.getDescription()==null?"":d.getDescription()) %></li>
        <li>有効: <%= d!=null && d.isActive()?"有効":"無効" %></li>
      </ul>
      <form method="post" action="<%= request.getContextPath() %>/admin/menu/maintenance/delete" onsubmit="return confirmDelete()">
        <input type="hidden" name="type" value="dish">
        <input type="hidden" name="id" value="<%= d==null?"":d.getId() %>">
        <button type="submit">削除する</button>
        <a class="btn-cancel" href="<%= request.getContextPath() %>/admin/menu/maintenance?section=category&categoryId=<%= d==null?"":d.getCategoryId() %>">キャンセル</a>
      </form>
    <% } else if ("course".equals(type)) { 
         Course c = (Course)request.getAttribute("course"); 
         if (c == null) { try { String idp = request.getParameter("id"); if (idp != null && idp.length() > 0) { c = new MenuDAO().getCourseById(Integer.parseInt(idp)); request.setAttribute("course", c); } } catch (Exception ignore) {} } 
    %>
      <p class="muted">以下のコースを削除します。よろしいですか？</p>
      <ul>
        <li>ID: <%= c==null?"":c.getId() %></li>
        <li>コース名: <%= c==null?"":c.getName() %></li>
        <li>価格: ¥<%= c==null?"":c.getPrice() %></li>
        <li>説明: <%= c==null?"":(c.getDescription()==null?"":c.getDescription()) %></li>
        <li>有効: <%= c!=null && c.isActive()?"有効":"無効" %></li>
      </ul>
      <form method="post" action="<%= request.getContextPath() %>/admin/menu/maintenance/delete" onsubmit="return confirmDelete()">
        <input type="hidden" name="type" value="course">
        <input type="hidden" name="id" value="<%= c==null?"":c.getId() %>">
        <button type="submit">削除する</button>
        <a class="btn-cancel" href="<%= request.getContextPath() %>/admin/menu/maintenance?section=course">キャンセル</a>
      </form>
    <% } else if ("category".equals(type)) { 
         Integer catId = (Integer)request.getAttribute("categoryId");
         if (catId == null) { try { String idp = request.getParameter("id"); if (idp != null && idp.length() > 0) catId = Integer.parseInt(idp); } catch (Exception ignore) {} }
         Category cat = (Category)request.getAttribute("category");
         String err = (String)request.getAttribute("error");
    %>
      <% if (err != null && err.length() > 0) { %>
        <div style="padding:10px;border:1px solid #fecaca;background:#fee2e2;color:#991b1b;border-radius:8px;margin-bottom:10px"><%= err %></div>
      <% } %>
      <p class="muted">カテゴリ <strong><%= (cat!=null?cat.getName():"(ID="+catId+")") %></strong> を削除します。よろしいですか？</p>
      <p class="muted">注: このカテゴリに料理が残っている場合、削除できません。</p>
      <form method="post" action="<%= request.getContextPath() %>/admin/menu/maintenance/delete" onsubmit="return confirmDelete()">
        <input type="hidden" name="type" value="category">
        <input type="hidden" name="id" value="<%= catId %>">
        <button type="submit">削除する</button>
        <a class="btn-cancel" href="<%= request.getContextPath() %>/admin/menu/maintenance?section=category">キャンセル</a>
      </form>
    <% } %>
  </div>
</div>
</body>
</html>

