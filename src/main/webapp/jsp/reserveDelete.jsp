<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.Reservation" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>予約の取り消し</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#dc2626; --primary-600:#b91c1c; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:720px;margin:0 auto;padding:32px 16px 64px}
  h1{font-size:24px;margin:0 0 16px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:20px}
  .row{margin:8px 0}
  .label{display:inline-block;width:120px;color:var(--muted)}
  .btn{display:inline-block;padding:10px 16px;border:none;border-radius:8px;background:var(--primary);color:#fff;cursor:pointer}
  .btn:hover{background:var(--primary-600)}
  .btn-muted{display:inline-block;padding:10px 16px;border:none;border-radius:8px;background:#6b7280;color:#fff;text-decoration:none}
  </style>
  <script>
    function confirmCancel(e){
      if(!confirm('本当に取り消しますか？')){ e.preventDefault(); return false; }
      return true;
    }
  </script>
</head>
<body>
<div class="container">
  <h1>予約の取り消し</h1>
  <%
    Reservation r = (Reservation)request.getAttribute("reservation");
    String courseName = (String)request.getAttribute("courseName");
    SimpleDateFormat dfmt = new SimpleDateFormat("yyyy年MM月dd日");
    SimpleDateFormat tfmt = new SimpleDateFormat("HH時mm分");
  %>
  <div class="card">
    <div class="row"><span class="label">予約番号</span><span><strong><%= r==null?"":r.getId() %></strong></span></div>
    <div class="row"><span class="label">日付</span><span><%= (r!=null && r.getStartTime()!=null) ? dfmt.format(r.getStartTime()) : "" %></span></div>
    <div class="row"><span class="label">時刻</span><span><%= (r!=null && r.getStartTime()!=null) ? tfmt.format(r.getStartTime()) : "" %></span></div>
    <div class="row"><span class="label">人数</span><span><%= r==null?"":r.getPartySize() %></span></div>
    <div class="row"><span class="label">コース</span><span><%= courseName==null?"":courseName %></span></div>

    <form method="post" action="<%= request.getContextPath() %>/reservations/delete" onsubmit="return confirmCancel(event)" style="margin-top:16px">
      <input type="hidden" name="id" value="<%= r==null?"":r.getId() %>">
      <button type="submit" class="btn">取り消し</button>
      <a class="btn-muted" href="<%= request.getContextPath() %>/reservations">戻る</a>
    </form>
  </div>

</div>
</body>
</html>
