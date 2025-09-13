<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="beans.Category,beans.Course,beans.Dish"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>メニューメンテナンス</title>
<link rel="stylesheet"
	href="<%= request.getContextPath() %>/assets/style.css">
<style>
:root { 
  --bg:#f6f8fa; 
  --text:#1f2937; 
  --muted:#6b7280; 
  --primary:#2563eb; 
  --border:#e5e7eb; 
  --surface:#fff; 
}

* { box-sizing: border-box; }
html, body { height: 100%; }

body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans JP', 'Hiragino Kaku Gothic ProN', Meiryo, sans-serif;
  color: var(--text);
  background: var(--bg);
  line-height: 1.5;
}

.container { max-width: 1000px; margin: 0 auto; padding: 24px 16px 64px; }

.top-nav {
  background: var(--surface);
  border-bottom: 1px solid var(--border);
  padding: 12px 16px;
  margin: -24px -16px 24px;
}
.top-nav a { margin-right: 12px; color: var(--primary); text-decoration: none; }
.top-nav a:hover { text-decoration: underline; }

h1 { font-size: 24px; margin: 0 0 16px; }
h2 { font-size: 20px; margin: 24px 0 12px; }

.card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 16px;
  margin: 12px 0;
}

table {
  width: 100%;
  border-collapse: collapse;
  background: var(--surface);
  /* 必要なら幅のブレ防止に有効化
  table-layout: fixed;
  */
}

th, td {
  padding: 8px;
  border-bottom: 1px solid var(--border);
  vertical-align: middle;     /* すべてのセルを縦中央 */
}

thead th { background: #f3f4f6; }

.muted { color: var(--muted); }

input[type=text],
input[type=number],
textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid var(--border);
  border-radius: 6px;
}

.inline { display: flex; gap: 8px; align-items: center; }

/* ▼ ここがポイント：td を table-cell のままにする */
td.actions {
  /* 以前の display:flex をやめる */
  display: table-cell;        /* table-cell に戻す */
  white-space: nowrap;        /* ボタンの改行を防止 */
  vertical-align: middle;     /* 念のため縦中央を強制 */
  padding: 8px;               /* 他セルと同じ余白 */
}

/* ボタン間の余白は margin で付ける */
td.actions .btn-link {
  display: inline-block;
  margin-right: 8px;
  line-height: 1.2;
}
td.actions .btn-link:last-child { margin-right: 0; }

.btn-link {
  display: inline-block;
  text-decoration: none;
  padding: 8px 10px;
  border: 1px solid var(--border);
  border-radius: 8px;
  background: #fff;
  color: #2563eb;
  text-align: center;
}

</style>
</head>
<body>
	<div class="container">
		<div class="top-nav">
			<a href="<%= request.getContextPath() %>/admin/menu">管理メニュー</a> <a
				href="<%= request.getContextPath() %>/admin/seats">席表示</a> <a
				href="<%= request.getContextPath() %>/admin/logout">ログアウト</a>
		</div>

		<h1>メニューメンテナンス</h1>

		<div
			style="display: grid; grid-template-columns: 260px 1fr; gap: 16px; align-items: start">
			<!-- 左側の表示 -->
			<div class="card" style="position: sticky; top: 16px">
				<h2 style="margin: 0 0 12px; font-size: 18px">表示切替</h2>
				<div style="display: grid; gap: 8px">
					<a class="btn-link"
						href="<%= request.getContextPath() %>/admin/menu/maintenance?section=course">コース料理</a>
				</div>
				<hr
					style="margin: 12px 0; border: none; border-top: 1px solid var(--border)">
				<h2 style="margin: 0 0 12px; font-size: 18px">一品料理・ジャンル</h2>
				<div style="display: grid; gap: 6px">
					<% List<Category> categories = (List<Category>)request.getAttribute("categories");
           Integer selectedCategoryId = (Integer)request.getAttribute("selectedCategoryId");
           if (categories != null) {
             for (Category cat : categories) { boolean sel = (selectedCategoryId!=null && selectedCategoryId==cat.getId()); %>
					<a class="btn-link"
						style="border-color:<%= sel?"#2563eb":"var(--border)" %>;color:<%= sel?"#2563eb":"inherit" %>"
						href="<%= request.getContextPath() %>/admin/menu/maintenance?section=category&categoryId=<%= cat.getId() %>"><%= cat.getName() %></a>
					<%   }
           } %>
				</div>
			</div>

			<!-- 右側の表示 -->
			<div>
				<% String section = (String)request.getAttribute("section"); if ("course".equals(section)) { %>

				<h2>メニュー表示</h2>
				<div class="card">
					<a class="btn-link"
						href="<%= request.getContextPath() %>/admin/menu/maintenance/insert?type=course">コース追加</a>
					<table>
						<thead>
							<tr>
								<th style="width: 80px">ID</th>
								<th>名前/説明/価格/有効</th>
								<th style="width: 240px">操作</th>
							</tr>
						</thead>
						<tbody>
							<% List<Course> courses = (List<Course>)request.getAttribute("courses");
               if (courses != null) {
                 for (Course c : courses) { %>
							<tr>
								<td><%= c.getId() %></td>
								<td>
									<div class="inline">
										<span><strong><%= c.getName() %></strong> </span>
									</div>
								</td>
								<td class="actions"><a class="btn-link"
									href="<%= request.getContextPath() %>/admin/menu/maintenance/course?id=<%= c.getId() %>">コース内容を編集</a>
									<a class="btn-link" style="margin-left: 8px"
									href="<%= request.getContextPath() %>/admin/menu/maintenance/delete?type=course&id=<%= c.getId() %>">削除</a>
								</td>
							</tr>
							<% } } %>
						</tbody>
					</table>
				</div>
				<% } else { %>
				<% Integer selectedCategoryId2 = (Integer)request.getAttribute("selectedCategoryId"); %>
				<% if (selectedCategoryId2 == null) { %>
				<p class="muted">左のジャンルから選択してください。</p>
				<% } else { %>
				<h2>ジャンル別料理</h2>
				<div class="card">
					<form class="inline" method="post"
						action="<%= request.getContextPath() %>/admin/menu/maintenance">
						<input type="hidden" name="type" value="category"> <input
							type="hidden" name="action" value="update"> <input
							type="hidden" name="id" value="<%= selectedCategoryId2 %>">
						<input type="text" name="name" placeholder="カテゴリ名を入力" required>
						<button type="submit">カテゴリ名を更新</button>
					</form>
					<a class="btn-link" style="margin-top: 8px; display: inline-block"
						href="<%= request.getContextPath() %>/admin/menu/maintenance/delete?type=category&id=<%= selectedCategoryId2 %>">カテゴリ削除</a>
				</div>

				<!-- 譁咏炊霑ｽ蜉 -->
				<div class="card">
					<a class="btn-link"
						href="<%= request.getContextPath() %>/admin/menu/maintenance/insert?type=dish&categoryId=<%= selectedCategoryId2 %>">新規追加</a>
				</div>

				<!-- 譁咏炊荳隕ｧ・ｽE・ｽ邱ｨ髮・蜑企勁・ｽE・ｽE-->
				<div class="card">
					<table>
						<thead>
							<tr>
								<th style="width: 70px">ID</th>
								<th style="width: 18%">名前</th>
								<th>説明</th>
								<th style="width: 100px">価格</th>
								<th style="width: 80px">有効</th>
								<th style="width: 200px">操作</th>
							</tr>
						</thead>
						<tbody>
							<% List<Dish> dishes = (List<Dish>)request.getAttribute("dishes");
                 if (dishes != null) {
                   for (Dish d : dishes) { %>
							<tr>
								<td><%= d.getId() %></td>
								<td>
									<div class="muted"><%= d.getName() %></div>
								</td>
								<td>
									<div class="muted"><%= d.getDescription()==null?"":d.getDescription() %></div>
								</td>
								<td>
									<div class="muted"><%= d.getPrice() %>円
									</div>
								</td>
								<td>
									<div class="muted"><%= d.isActive()?"販売中":"停止中" %></div>
								</td>
								<td class="actions"><a class="btn-link"
									href="<%= request.getContextPath() %>/admin/menu/maintenance/update?type=dish&id=<%= d.getId() %>">変更</a>
									<a class="btn-link"
									href="<%= request.getContextPath() %>/admin/menu/maintenance/delete?type=dish&id=<%= d.getId() %>">削除</a>
								</td>
							</tr>
							<% } } %>
						</tbody>
					</table>
				</div>
				<% } %>
				<% } %>
			</div>
		</div>

	</div>
</body>
</html>
