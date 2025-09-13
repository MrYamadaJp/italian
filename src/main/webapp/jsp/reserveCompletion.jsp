<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="beans.Reservation" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ご予約完了</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --primary-600:#1d4ed8; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:720px;margin:0 auto;padding:32px 16px 64px}
  h1{font-size:24px;margin:0 0 16px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:20px}
  .alert{padding:10px 12px;border-radius:6px;margin:12px 0}
  .alert.error{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
  .btn{display:inline-block;padding:10px 16px;border:none;border-radius:8px;background:var(--primary);color:#fff;cursor:pointer;text-decoration:none}
  .btn:hover{background:var(--primary-600)}
  p{margin:10px 0}
  </style>
</head>
<body>
<div class="container">
  <h1>ご予約完了</h1>

  <%
    String errorKey = (String)request.getAttribute("errorKey");
    if (errorKey != null) {
      String msg;
      switch (errorKey) {
        case "INVALID_TIME_INCREMENT": msg = "開始時刻は15分刻みで入力してください"; break;
        case "TIME_OUT_OF_RANGE": msg = "開始時刻は17:00〜21:00の間で選択してください"; break;
        case "END_AFTER_MIDNIGHT": msg = "終了が24:00を超えるため予約できません"; break;
        case "OUT_OF_BOOKING_WINDOW": msg = "予約可能期間外です（現在は1年以内のみ）"; break;
        case "FULLY_BOOKED": msg = "満席のため予約できません"; break;
        case "INVALID_INPUT":
        default: msg = "入力値が不正です";
      }
  %>
    <div class="alert error"><%= msg %></div>
    <p><a class="btn" href="<%= request.getContextPath() %>/reservations/form">戻る</a></p>
  <%
    } else {
      Reservation r = (Reservation)request.getAttribute("reservation");
      Integer reservationId = (Integer)request.getAttribute("reservationId");
      String customerName = (String)request.getAttribute("customerName");
      String courseName = (String)request.getAttribute("courseName");
      SimpleDateFormat fmt = new SimpleDateFormat("yyyy年MM月dd日 HH時mm分");
  %>
    <div class="card">
      <p><strong><%= customerName == null ? "お客様" : customerName %></strong> 様、 ご予約が完了いたしました。</p>
      <p><%= r != null && r.getStartTime() != null ? fmt.format(r.getStartTime()) : "" %> より</p>
      <p><%= courseName == null ? "コース" : courseName %>　<%= r == null ? "" : r.getPartySize() %>名様</p>
      <p>ご予約番号は <strong><%= reservationId %></strong> 番です。</p>
      <p>ご来店の際、受付にお申し付けください。</p>
    </div>
    <p style="margin-top:16px"><a class="btn" href="<%= request.getContextPath() %>/reservations">予約一覧へ</a></p>
  <%
    }
  %>

</div>
</body>
</html>
