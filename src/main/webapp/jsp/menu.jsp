<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="beans.Category,beans.Dish,beans.Course" %>
<%
  List<Course> courses = (List<Course>) request.getAttribute("courses");
  List<Category> categories = (List<Category>) request.getAttribute("categories");
  Map<Integer, List<Dish>> dishesByCategory = (Map<Integer, List<Dish>>) request.getAttribute("dishesByCategory");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>メニュー一覧</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --primary-600:#1d4ed8; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box}
  html,body{height:100%}
  body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:960px;margin:0 auto;padding:24px 16px 48px}
  .top-nav{background:var(--surface);border-bottom:1px solid var(--border);padding:12px 16px;margin:-24px -16px 24px}
  .top-nav a{margin-right:12px;color:var(--primary);text-decoration:none}
  .top-nav a:hover{text-decoration:underline}
  h1{font-size:24px;margin:0 0 12px}
  h2{font-size:20px;margin:0 0 12px}
  .view-toggle{display:flex;gap:12px;margin:16px 0 24px}
  .toggle-btn{flex:1 1 0;padding:12px 0;border:1px solid var(--border);border-radius:999px;background:var(--surface);color:var(--text);font-size:15px;font-weight:600;cursor:pointer;transition:all .2s ease}
  .toggle-btn:hover{border-color:var(--primary);color:var(--primary)}
  .toggle-btn.active{background:var(--primary);border-color:var(--primary);color:#fff;box-shadow:0 8px 20px -12px rgba(37,99,235,.8)}
  .toggle-btn:focus-visible{outline:3px solid rgba(37,99,235,.35);outline-offset:3px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:8px;padding:16px;margin:12px 0}
  .muted{color:var(--muted)}
  table{width:100%;border-collapse:collapse;background:var(--surface)}
  th,td{padding:10px 12px;border-bottom:1px solid var(--border);text-align:left}
  thead th{background:#f3f4f6}
  tr:nth-child(even) td{background:#fafafa}
  .view-section{display:none;animation:fade .25s ease}
  .view-section.is-active{display:block}
  .course-list{list-style:none;margin:0;padding:0}
  .course-item + .course-item{margin-top:4px}
  .course-toggle{width:100%;display:flex;justify-content:space-between;align-items:center;gap:16px;padding:16px 0;background:none;border:0;font-size:16px;font-weight:600;color:var(--text);text-align:left;cursor:pointer;transition:color .2s ease}
  .course-toggle:hover{color:var(--primary)}
  .course-toggle:focus-visible{outline:3px solid rgba(37,99,235,.35);outline-offset:3px}
  .course-toggle .course-title{flex:1 1 auto;min-width:120px}
  .course-toggle .course-meta{display:flex;align-items:center;gap:12px;white-space:nowrap;font-size:15px}
  .course-toggle .price{color:var(--primary-600)}
  .course-toggle::after{content:'+';font-weight:700;font-size:18px;transition:transform .25s ease}
  .course-toggle[aria-expanded="true"]::after{transform:rotate(45deg)}
  .course-details{border-top:1px solid var(--border);margin-top:-4px;padding:0;overflow:hidden;max-height:0;transition:max-height .3s ease, padding .3s ease}
  .course-details.open{padding:12px 0 16px}
  .course-description{margin:0;color:var(--muted);font-size:14px;line-height:1.6}
  @keyframes fade{from{opacity:0;transform:translateY(6px)}to{opacity:1;transform:none}}
  </style>
</head>
<body>
<div class="container">
  <div class="top-nav">
    <a href="<%= request.getContextPath() %>/">ホーム</a>
  </div>

  <h1>メニュー一覧</h1>
  <p class="muted" style="margin:0 0 8px;">下のボタンでコースメニューと単品メニューを切り替えられます。</p>

  <div class="view-toggle" role="tablist" aria-label="メニュー表示切替">
    <button type="button" class="toggle-btn active" data-target="courses" role="tab" aria-selected="true">コース</button>
    <button type="button" class="toggle-btn" data-target="dishes" role="tab" aria-selected="false">単品メニュー</button>
  </div>

  <section class="view-section is-active" data-view="courses" aria-labelledby="courses-tab">
    <h2 id="courses-tab">コース一覧</h2>
    <div class="card">
      <ul class="course-list">
        <%
          if (courses != null && !courses.isEmpty()) {
            for (Course c : courses) {
              String rawDesc = c.getDescription();
              String displayDesc = (rawDesc != null && !rawDesc.trim().isEmpty()) ? rawDesc : "詳細情報は準備中です。";
        %>
        <li class="course-item">
          <button type="button" class="course-toggle" data-target="course-<%= c.getId() %>" aria-expanded="false">
            <span class="course-title"><%= c.getName() %></span>
            <span class="course-meta">
              <span class="price">¥<%= c.getPrice() %></span>
            </span>
          </button>
          <div id="course-<%= c.getId() %>" class="course-details" hidden>
            <p class="course-description"><%= displayDesc.replaceAll("\\n", "<br>") %></p>
          </div>
        </li>
        <%
            }
          } else {
        %>
        <li class="muted">現在、表示できるコースはありません。</li>
        <%
          }
        %>
      </ul>
    </div>
  </section>

  <section class="view-section" data-view="dishes" aria-labelledby="dishes-tab" hidden>
    <h2 id="dishes-tab">単品メニュー</h2>
    <%
      if (categories != null && !categories.isEmpty()) {
        for (Category cat : categories) {
          List<Dish> dishes = dishesByCategory != null ? dishesByCategory.get(cat.getId()) : null;
    %>
      <div class="card">
        <h3 style="margin:0 0 8px;font-size:18px;">カテゴリー：<%= cat.getName() %></h3>
        <%
          if (dishes != null && !dishes.isEmpty()) {
        %>
        <table>
          <thead>
            <tr>
              <th style="width:25%">料理名</th>
              <th>説明</th>
              <th style="width:15%">価格</th>
            </tr>
          </thead>
          <tbody>
          <%
            for (Dish d : dishes) {
          %>
            <tr>
              <td><%= d.getName() %></td>
              <td><%= d.getDescription() %></td>
              <td>¥<%= d.getPrice() %></td>
            </tr>
          <%
            }
          %>
          </tbody>
        </table>
        <%
          } else {
        %>
          <p class="muted" style="margin:8px 0 0;">現在、このカテゴリーにメニューはありません。</p>
        <%
          }
        %>
      </div>
    <%
        }
      } else {
    %>
      <div class="card">
        <p class="muted" style="margin:0">現在、表示できるメニューはありません。</p>
      </div>
    <%
      }
    %>
  </section>
</div>

<script>
(function(){
  const buttons = document.querySelectorAll('.toggle-btn');
  const sections = document.querySelectorAll('.view-section');
  buttons.forEach(btn => {
    btn.addEventListener('click', () => {
      if (btn.classList.contains('active')) return;
      buttons.forEach(b => {
        const isActive = b === btn;
        b.classList.toggle('active', isActive);
        b.setAttribute('aria-selected', isActive ? 'true' : 'false');
      });
      const target = btn.dataset.target;
      sections.forEach(section => {
        const isMatch = section.dataset.view === target;
        section.classList.toggle('is-active', isMatch);
        section.hidden = !isMatch;
      });
    });
  });
})();

(function(){
  const courseButtons = document.querySelectorAll('.course-toggle');
  courseButtons.forEach(btn => {
    const targetId = btn.dataset.target;
    const details = document.getElementById(targetId);
    if (!details) return;
    details.hidden = true;
    details.style.maxHeight = '0px';

    const clearTransitionHandler = () => {
      if (details._transitionHandler) {
        details.removeEventListener('transitionend', details._transitionHandler);
        details._transitionHandler = null;
      }
    };

    btn.addEventListener('click', () => {
      const isExpanded = btn.getAttribute('aria-expanded') === 'true';
      clearTransitionHandler();

      if (isExpanded) {
        btn.setAttribute('aria-expanded', 'false');
        details.style.maxHeight = details.scrollHeight + 'px';
        requestAnimationFrame(() => {
          details.style.maxHeight = '0px';
          details.classList.remove('open');
        });
        const onClose = event => {
          if (event.propertyName !== 'max-height') return;
          details.hidden = true;
          details.style.maxHeight = '0px';
          clearTransitionHandler();
        };
        details._transitionHandler = onClose;
        details.addEventListener('transitionend', onClose);
      } else {
        btn.setAttribute('aria-expanded', 'true');
        details.hidden = false;
        details.classList.add('open');
        details.style.maxHeight = '0px';
        requestAnimationFrame(() => {
          details.style.maxHeight = details.scrollHeight + 'px';
        });
        const onOpen = event => {
          if (event.propertyName !== 'max-height') return;
          details.style.maxHeight = 'none';
          clearTransitionHandler();
        };
        details._transitionHandler = onOpen;
        details.addEventListener('transitionend', onOpen);
      }
    });
  });
})();
</script>
</body>
</html>
