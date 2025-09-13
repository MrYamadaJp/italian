<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="beans.Reservation" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ご予約一覧</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --primary-600:#1d4ed8; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:960px;margin:0 auto;padding:24px 16px 48px}
  .top-nav{background:var(--surface);border-bottom:1px solid var(--border);padding:12px 16px;margin:-24px -16px 24px}
  .top-nav a,.top-nav button{margin-right:12px;text-decoration:none}
  h1{font-size:24px;margin:0 0 16px}
  table{width:100%;border-collapse:collapse;background:var(--surface)} th,td{padding:10px 12px;border-bottom:1px solid var(--border);text-align:left} thead th{background:#f3f4f6} tr:nth-child(even) td{background:#fafafa}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:8px;padding:16px;margin:12px 0}
  .btn{display:inline-block;padding:8px 14px;border:none;border-radius:6px;background:var(--primary);color:#fff;cursor:pointer}
  .btn:hover{background:var(--primary-600)}
  .btn-link{display:inline-block;padding:8px 14px;border:1px solid var(--border);border-radius:6px;background:#fff;color:var(--primary);text-decoration:none}
  .btn-link:hover{background:#f3f6ff}
  </style>
</head>
<body>
<div class="container">
  <div class="top-nav">
    <a class="btn-link" href="<%= request.getContextPath() %>/reservations">ご予約</a>
    <a class="btn-link" href="<%= request.getContextPath() %>/reservations/form">新規ご予約</a>
    <a class="btn-link" href="<%= request.getContextPath() %>/">ホーム</a>
  </div>

  <h1>ご予約一覧</h1>
  <%
    List<Reservation> list = (List<Reservation>)request.getAttribute("reservations");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
  %>
  <div class="card">
    <div style="margin-bottom:12px">
      <a class="btn" href="<%= request.getContextPath() %>/reservations/form">新規ご予約</a>
    </div>
    <table>
      <thead>
        <tr><th>ID</th><th>開始時刻</th><th>終了時刻</th><th>人数</th><th>状態</th><th>操作</th></tr>
      </thead>
      <tbody>
      <% if (list != null) { for (Reservation r : list) {
           String status = r.getStatus();
           String statusJa = "不明";
           if ("BOOKED".equals(status)) statusJa = "予約中";
           else if ("CANCELLED".equals(status)) statusJa = "取消済み";
      %>
      <tr>
        <td><%= r.getId() %></td>
        <td><%= r.getStartTime() == null ? "" : sdf.format(r.getStartTime()) %></td>
        <td><%= r.getEndTime() == null ? "" : sdf.format(r.getEndTime()) %></td>
        <td><%= r.getPartySize() %></td>
        <td><%= statusJa %></td>
        <td>
          <% if ("BOOKED".equals(status)) { %>
            <a class="btn-link" href="<%= request.getContextPath() %>/reservations/delete?id=<%= r.getId() %>">取消</a>
            <a class="btn-link" href="<%= request.getContextPath() %>/reservations/update?id=<%= r.getId() %>">予約内容の変更</a>
          <% } %>
        </td>
      </tr>
      <% } } %>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>
