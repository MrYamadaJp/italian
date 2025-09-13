<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="beans.Category,beans.Dish,beans.Course" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>コース更新</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
  <style>
  :root { --bg:#f6f8fa; --text:#1f2937; --muted:#6b7280; --primary:#2563eb; --border:#e5e7eb; --surface:#fff; }
  *{box-sizing:border-box} html,body{height:100%} body{margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans JP','Hiragino Kaku Gothic ProN',Meiryo,sans-serif;color:var(--text);background:var(--bg);line-height:1.5}
  .container{max-width:900px;margin:0 auto;padding:32px 16px 64px}
  .card{background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:20px;margin:16px 0}
  .inline{display:flex;gap:8px;align-items:center;justify-content:flex-start}
  input[type=text], input[type=number], textarea, select{width:100%;padding:10px;border:1px solid var(--border);border-radius:8px;font:inherit}
  input[type=checkbox]{width:auto;margin:0}
  label{display:block;margin:10px 0 6px;font-weight:600}
  button{padding:10px 14px;border:none;border-radius:8px;background:#2563eb;color:#fff;cursor:pointer}
  button:hover{background:#1d4ed8}
  .grid2{display:grid;grid-template-columns:1fr 1fr;gap:16px}
  h2{font-size:20px;margin:24px 0 12px}
  .muted{color:var(--muted)}
  </style>
</head>
<body>
<div class="container">
  <h1>コース更新</h1>

  <% Course course = (Course)request.getAttribute("course"); %>
  <form method="post" action="<%= request.getContextPath() %>/admin/menu/maintenance/update">
    <input type="hidden" name="type" value="course">
    <input type="hidden" name="id" value="<%= course==null?"":course.getId() %>">

    <div class="card">
      <label>コース名（必須）</label>
      <input type="text" name="name" value="<%= course==null?"":course.getName() %>" required>
      <label>価格（必須）</label>
      <input type="number" name="price" value="<%= course==null?"":course.getPrice() %>" required>
      <label>オーダー可（必須）</label>
      <select name="orderable" required>
        <option value="1" <%= (course!=null && course.isActive())?"selected":"" %>>可</option>
        <option value="0" <%= (course!=null && !course.isActive())?"selected":"" %>>不可</option>
      </select>
      <label>コメント</label>
      <input type="text" name="description" value="<%= course==null?"":(course.getDescription()==null?"":course.getDescription()) %>">
    </div>

    <%
      List<Category> categories = (List<Category>)request.getAttribute("categories");
      List<Dish> allDishes = (List<Dish>)request.getAttribute("allDishes");
      List<Integer> selected = (List<Integer>)request.getAttribute("selectedDishIds");
      Map<Integer,String> catNames = new HashMap<>();
      if (categories != null) {
        for (Category c : categories) catNames.put(c.getId(), c.getName());
      }
      class Section { String label; String[] keys; Section(String l, String... k){label=l; keys=k;} }
      List<Section> sections = Arrays.asList(
        new Section("前菜", "前菜", "Antipasto", "Antipasti"),
        new Section("スープ", "スープ", "Soup"),
        new Section("パスタ", "パスタ", "Pasta"),
        new Section("肉料理", "肉", "Meat", "Main"),
        new Section("魚料理", "魚", "Fish", "Seafood"),
        new Section("デザート", "デザート", "Dolce", "Dessert")
      );
    %>

    <div class="grid2">
      <% for (Section s : sections) { %>
        <div class="card">
          <h2><%= s.label %></h2>
          <%
            java.util.List<Dish> candidates = new java.util.ArrayList<>();
            Integer selectedVal = null;
            if (allDishes != null) {
              for (Dish d : allDishes) {
                String cn = catNames.get(d.getCategoryId());
                if (cn != null) {
                  boolean match = false;
                  for (String key : s.keys) {
                    if (cn.toLowerCase(java.util.Locale.ROOT).contains(key.toLowerCase(java.util.Locale.ROOT))) { match = true; break; }
                  }
                  if (match) {
                    candidates.add(d);
                    if (selected != null && selected.contains(d.getId()) && selectedVal == null) {
                      selectedVal = d.getId();
                    }
                  }
                }
              }
            }
            if (candidates.isEmpty()) {
          %>
              <p class="muted">メニューが存在していません</p>
          <%
            } else {
          %>
              <select name="dishIds">
                <option value="">選択してください</option>
                <% for (Dish d : candidates) { %>
                  <option value="<%= d.getId() %>" <%= (selectedVal!=null && selectedVal==d.getId())?"selected":"" %>><%= d.getName() %>（¥<%= d.getPrice() %>）</option>
                <% } %>
              </select>
          <%
            }
          %>
        </div>
      <% } %>
    </div>

    <div class="inline" style="margin-top:12px">
      <button type="submit">保存</button>
      <a class="inline" href="<%= request.getContextPath() %>/admin/menu/maintenance?section=course" style="text-decoration:none;padding:10px 14px;border:1px solid var(--border);border-radius:8px;color:#2563eb">キャンセル</a>
    </div>
  </form>

</div>
</body>
</html>
