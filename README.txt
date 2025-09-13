Italian Reservation System (Servlet/JSP)

概要
- Eclipse/Pleiades（WTP）向け Java Servlet/JSP プロジェクト
- ランタイム: Java 8 / Tomcat 8.5
- Web ルート: `src/main/webapp`（`WebContent` は旧構成のため削除済み）

DB 接続（必要に応じて編集）
- 設定: `src/main/java/resources/database.properties`
  - Host: 127.0.0.1
  - DB: italian
  - User: root
  - Password: root

管理者デフォルト認証
- username: admin
- password: admin1234
（`sql/seed.sql` で salt+SHA-256 により登録）

セットアップ（Eclipse/Pleiades）
1) Import: File > Import > Existing Projects into Workspace
2) Project Facets: Dynamic Web Module 3.1 / Java 1.8 を有効
3) Targeted Runtimes: Tomcat 8 を選択
4) Deployment Assembly:
   - `/src/main/webapp` → `/`
   - `/src/main/java` → `/WEB-INF/classes`（必要なら `build/classes` → `/WEB-INF/classes` も追加）
5) Java Build Path:
   - Source: `src/main/java`
   - Default output: `build/classes`
6) Serversビューに追加 → Start → Publish（必要に応じて Clean Tomcat Work Directory）
7) JDBC ドライバ: `src/main/webapp/WEB-INF/lib/mysql-connector-j-8.4.0.jar` 同梱

主要パス
- `src/main/webapp/WEB-INF/web.xml`: サーブレット/フィルタ/ウェルカム設定（metadata-complete="true"）
- `src/main/webapp/jsp/*`: 画面（home/menu 等）
- `src/main/java/beans/*`: エンティティ
- `src/main/java/dao/*`: JDBC DAO
- `src/main/java/servlet/*`: サーブレット
- `src/main/java/filters/*`: フィルタ（認可/エンコーディング）
- `src/main/java/utils/*`: 共通ユーティリティ（DB, PasswordUtil, TokenUtil）
- `sql/ddl.sql`, `sql/seed.sql`: スキーマ/初期データ

トップ/ナビゲーション
- ウェルカム: `/home`（HomeServlet → `jsp/home.jsp`）
- ルート `/` は `index.jsp` により `/home` へリダイレクト
- `jsp/home.jsp` には GitHub（プロジェクト）ボタンを追加済み

主な機能
- 公開メニュー: `/menu` → `MenuPublicServlet` → `jsp/menu.jsp`
- ユーザーメニュー/予約:
  - 予約一覧: `/reservations` → `ReservationListServlet` → `jsp/reserveList.jsp`
  - 新規予約: `/reservations/form` → `ReservationFormServlet` → `jsp/reserveInsert.jsp`
  - 予約作成: `/reservations/create`（POST）→ `ReservationCreateServlet` → `jsp/reserveCompletion.jsp`
  - 予約更新: `/reservations/update`（GET/POST）→ `ReservationUpdateServlet` → `jsp/reserveUpdate.jsp`
  - 予約取消確認: `/reservations/delete`（GET/POST）→ `ReservationDeleteServlet` → `jsp/reserveDelete.jsp`
- アカウント:
  - 情報変更: `/account/edit` → `AccountEditServlet` → `jsp/account_edit.jsp`
  - 脱会: `/account/withdraw` → `AccountWithdrawServlet` → `jsp/account_withdraw.jsp`
- 認可: `/account/*` と `/reservations/*` は `CustomerAuthFilter` で保護

仕様（抜粋）
- 開始時刻: 17:00〜21:00、UI 30分刻み、サーバ検証 15分刻み
- 滞在: 2時間59分、日付跨ぎ不可（24:00越え不可）
- 期間: 現在〜1年以内
- 席割り: 収容人数以上の最小テーブルを選択（相席なし）

最近の変更（2025‑09‑13）
- カテゴリ削除時の空白画面を解消（確認にカテゴリ名、FK制約時にエラー表示）
- 「有効」チェックボックスを左寄せ（追加/更新画面）
- ホームに GitHub ボタン追加、`index.jsp` による `/` → `/home` リダイレクト
- `@WebFilter` を撤去し、web.xml 優先（metadata-complete）
- 旧 `WebContent` を削除（`src/main/webapp` に統一）

トラブルシュート
- 404/起動失敗時:
  1) Problems ビューのエラー（他プロジェクト含む）解消
  2) Deployment Assembly/Build Path を上記に合わせる
  3) Servers: Stop → Clean Tomcat Work Directory → Project > Clean… → Start → Publish
  4) 配備先に `WEB-INF/classes/servlet/HomeServlet.class` があるか確認
- Remember-me が原因で失敗する場合:
  - 一時的に web.xml の RememberMeFilter をコメントアウト（現在は無効化済み）
  - `filters/RememberMeFilter`, `utils/TokenUtil`, `dao/RememberTokenDAO` が配備されたらコメント解除

主なURL
- `/`, `/home`, `/menu`, `/login`, `/register`, `/admin/login`

