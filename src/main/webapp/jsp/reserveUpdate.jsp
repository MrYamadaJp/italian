<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="beans.Course,beans.Reservation" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>予約内容の変更</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --primary-600:#1d4ed8; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:960px;margin:0 auto;padding:24px 16px 48px}
  .top-nav{background:var(--surface);border-bottom:1px solid var(--border);padding:12px 16px;margin:-24px -16px 24px}
  .top-nav a{margin-right:12px;color:var(--primary);text-decoration:none} .top-nav a:hover{text-decoration:underline}
  h1{font-size:24px;margin:0 0 16px}
  label{display:block;margin:10px 0}
  select,input[type="date"],input[type="number"]{width:100%;max-width:320px;padding:8px;border:1px solid var(--border);border-radius:6px;font:inherit}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:8px;padding:16px;margin:12px 0}
  button{display:inline-block;padding:8px 14px;border:none;border-radius:6px;background:var(--primary);color:#fff;cursor:pointer} button:hover{background:var(--primary-600)}
  .muted{color:var(--muted)}
  </style>
</head>
<body>
<div class="container">
  <div class="top-nav">
    <a href="<%= request.getContextPath() %>/reservations">ご予約</a>
    <a href="<%= request.getContextPath() %>/reservations/form">新規ご予約</a>
    <a href="<%= request.getContextPath() %>/">ホーム</a>
  </div>

  <h1>予約内容の変更</h1>
  <% 
     List<Course> courses = (List<Course>)request.getAttribute("courses"); 
     Reservation res = (Reservation)request.getAttribute("reservation");
     String dateStr = "";
     String timeStr = "";
     Integer party = null;
     Integer courseId = null;
     if (res != null) {
       dateStr = new SimpleDateFormat("yyyy-MM-dd").format(res.getStartTime());
       timeStr = new SimpleDateFormat("HH:mm").format(res.getStartTime());
       party = res.getPartySize();
       courseId = res.getCourseId();
     }
  %>
  <div class="card">
    <form method="post" action="<%= request.getContextPath() %>/reservations/update">
      <% String idParam = request.getParameter("id"); %>
      <p class="muted">予約ID: <strong><%= idParam == null ? (res == null ? "" : res.getId()) : idParam %></strong></p>
      <input type="hidden" name="id" value="<%= idParam == null ? (res == null ? "" : res.getId()) : idParam %>">
      <label>予約日
        <input type="date" name="date" value="<%= dateStr %>" required>
      </label>
      <label>開始時刻（17:00〜21:00／30分刻み）
        <select name="time" required>
          <option value="">選択してください</option>
          <option value="17:00" <%= "17:00".equals(timeStr)?"selected":"" %>>17:00</option>
          <option value="17:30" <%= "17:30".equals(timeStr)?"selected":"" %>>17:30</option>
          <option value="18:00" <%= "18:00".equals(timeStr)?"selected":"" %>>18:00</option>
          <option value="18:30" <%= "18:30".equals(timeStr)?"selected":"" %>>18:30</option>
          <option value="19:00" <%= "19:00".equals(timeStr)?"selected":"" %>>19:00</option>
          <option value="19:30" <%= "19:30".equals(timeStr)?"selected":"" %>>19:30</option>
          <option value="20:00" <%= "20:00".equals(timeStr)?"selected":"" %>>20:00</option>
          <option value="20:30" <%= "20:30".equals(timeStr)?"selected":"" %>>20:30</option>
          <option value="21:00" <%= "21:00".equals(timeStr)?"selected":"" %>>21:00</option>
        </select>
      </label>
      <label>人数（1〜6名）
        <select name="partySize" required>
          <option value="">選択してください</option>
          <option value="1" <%= (party!=null && party==1)?"selected":"" %>>1</option>
          <option value="2" <%= (party!=null && party==2)?"selected":"" %>>2</option>
          <option value="3" <%= (party!=null && party==3)?"selected":"" %>>3</option>
          <option value="4" <%= (party!=null && party==4)?"selected":"" %>>4</option>
          <option value="5" <%= (party!=null && party==5)?"selected":"" %>>5</option>
          <option value="6" <%= (party!=null && party==6)?"selected":"" %>>6</option>
        </select>
      </label>
      <label>コース
        <select name="courseId" required>
          <% if (courses != null) { for (Course c : courses) { %>
            <option value="<%= c.getId() %>" <%= (courseId!=null && courseId==c.getId())?"selected":"" %>><%= c.getName() %> (¥<%= c.getPrice() %>)</option>
          <% } } %>
        </select>
      </label>
      <button type="submit">変更を保存する</button>
    </form>
  </div>
  <p class="muted"><a href="<%= request.getContextPath() %>/reservations">ご予約一覧に戻る</a></p>
</div>
</body>
</html>
