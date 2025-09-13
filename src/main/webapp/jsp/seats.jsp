<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.TableDAO" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>席状態表示</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --ok:#16a34a; --danger:#ef4444; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:960px;margin:0 auto;padding:24px 16px 48px}
  .top-nav{background:var(--surface);border-bottom:1px solid var(--border);padding:12px 16px;margin:-24px -16px 24px}
  .top-nav a{margin-right:12px;color:var(--primary);text-decoration:none} .top-nav a:hover{text-decoration:underline}
  h1{font-size:24px;margin:0 0 16px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:8px;padding:16px;margin:12px 0}
  .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:12px}
  .seat{border:1px solid var(--border);border-radius:10px;padding:12px;background:#fff}
  .status-ok{color:var(--ok)} .status-ng{color:#b91c1c}
  label{display:block;margin:8px 0 4px;font-weight:600}
  input,select{padding:8px;border:1px solid var(--border);border-radius:8px}
  button{padding:8px 12px;border:none;border-radius:8px;background:var(--primary);color:#fff;cursor:pointer}
  button:hover{background:#1d4ed8}
  </style>
</head>
<body>
<div class="container">
  <div class="top-nav">
    <a href="<%= request.getContextPath() %>/admin/menu/maintenance">メンテナンス</a>
    <a href="<%= request.getContextPath() %>/admin/logout">ログオフ</a>
  </div>

  <h1>席状態表示</h1>
  <div class="card">
    <form method="get" action="<%= request.getContextPath() %>/admin/seats" class="inline" style="display:flex;gap:8px;align-items:flex-end;flex-wrap:wrap">
      <div>
        <label>日付</label>
        <input type="date" name="date" value="<%= request.getParameter("date") == null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) : request.getParameter("date") %>" required>
      </div>
      <div>
        <label>開始時刻</label>
        <select name="time" required>
          <% String tm = request.getParameter("time"); String[] slots = new String[]{"17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00"};
             for (String s : slots) { %>
            <option value="<%= s %>" <%= s.equals(tm)?"selected":"" %>><%= s %></option>
          <% } %>
        </select>
      </div>
      <div>
        <button type="submit">表示</button>
      </div>
    </form>
  </div>

  <% java.util.Date at = (java.util.Date)request.getAttribute("at"); if (at != null) { %>
  <p class="muted">表示日時: <%= new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm").format(at) %></p>
  <div class="grid">
    <% java.util.List<TableDAO.TableStatus> statuses = (java.util.List<TableDAO.TableStatus>)request.getAttribute("statuses");
       if (statuses != null) {
         for (TableDAO.TableStatus s : statuses) { %>
      <div class="seat">
        <div><strong><%= s.table.getName() %></strong>（<%= s.table.getCapacity() %>名）</div>
        <% if (s.occupied) { %>
          <div class="status-ng">予約済み（<%= s.partySize == null? "" : s.partySize %>名）</div>
          <div class="muted"> <%= new java.text.SimpleDateFormat("HH:mm").format(s.startTime) %> - <%= new java.text.SimpleDateFormat("HH:mm").format(s.endTime) %> </div>
        <% } else { %>
          <div class="status-ok">空席</div>
        <% } %>
      </div>
    <% } } %>
  </div>
  <% } %>

</div>
</body>
</html>

