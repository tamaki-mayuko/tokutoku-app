-- ============================================================
-- 徳徳ネット PoC用 データベース設定
-- Supabase の「SQL Editor」にこのファイルの中身を全部貼り付けて
-- 「Run」を押すだけで完了します。
-- ============================================================

-- 会員(高齢者・家族の両方)
create table members (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,            -- 合言葉(ログイン用。導入会で紙で渡す)
  name text not null,
  age int,
  role text not null default 'senior',  -- 'senior' か 'family'
  family_of uuid references members(id),-- family のとき:見守る高齢者のid
  can_do text[] default '{}',
  want_help text[] default '{}',
  toku int not null default 3,          -- 登録記念の3枚からスタート
  created_at timestamptz default now()
);

-- 依頼(してほしいこと)
create table requests (
  id uuid primary key default gen_random_uuid(),
  member_id uuid not null references members(id),
  need text not null,                   -- スキルid (kaimono, denkyu など)
  need_text text not null,
  when_text text,
  status text not null default 'open',  -- open / matched / done
  helper_id uuid references members(id),
  created_at timestamptz default now()
);

-- 徳通帳(記録)
create table ledger (
  id uuid primary key default gen_random_uuid(),
  member_id uuid not null references members(id),
  descr text not null,
  amount int not null,
  kind text not null default 'self',    -- self / family / circle
  created_at timestamptz default now()
);

-- 見守り通知(家族に届く)
create table notices (
  id uuid primary key default gen_random_uuid(),
  senior_id uuid not null references members(id),
  emoji text default '📮',
  body text not null,
  created_at timestamptz default now()
);

-- 座(サークル)
create table circles (
  id text primary key,
  emoji text, name text not null, descr text, when_text text, place text
);

create table circle_members (
  circle_id text references circles(id),
  member_id uuid references members(id),
  primary key (circle_id, member_id)
);

-- 家族の「行い」の記録(仕送り徳の重複防止)
create table family_deeds (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references members(id),
  task_id text not null,
  created_at timestamptz default now(),
  unique (family_id, task_id)
);

-- ============================================================
-- PoC用のアクセス設定
-- 注意:PoC期間中は「合言葉を知っている人だけが参加」という前提で
-- 簡易な設定にしています。本格運用の前には必ず認証(Supabase Auth)と
-- 行レベルセキュリティの厳格化を行ってください。
-- ============================================================
alter table members enable row level security;
alter table requests enable row level security;
alter table ledger enable row level security;
alter table notices enable row level security;
alter table circles enable row level security;
alter table circle_members enable row level security;
alter table family_deeds enable row level security;

create policy poc_all on members for all using (true) with check (true);
create policy poc_all on requests for all using (true) with check (true);
create policy poc_all on ledger for all using (true) with check (true);
create policy poc_all on notices for all using (true) with check (true);
create policy poc_all on circles for select using (true);
create policy poc_all on circle_members for all using (true) with check (true);
create policy poc_all on family_deeds for all using (true) with check (true);

-- ============================================================
-- 初期データ:座
-- ============================================================
insert into circles (id, emoji, name, descr, when_text, place) values
 ('cha','🍵','水曜お茶の座','お菓子を持ち寄っておしゃべり','毎週水曜 14時','第2集会所'),
 ('igo','⚫','囲碁・将棋の座','初心者歓迎。見学だけでも','毎週土曜 10時','公民館'),
 ('sanpo','🚶','朝の散歩の座','公園を一周してラジオ体操','毎朝 7時','中央公園 入口'),
 ('yosai','🧵','洋裁とつくろいの座','繕いもの持ち込み歓迎','第2・4金曜','第2集会所');

-- ============================================================
-- 動作確認用のお試し会員(あとで消してOK)
-- 合言葉:sakura / ume / hina
-- ============================================================
insert into members (code, name, age, role, can_do, want_help) values
 ('sakura','試験 花子', 68, 'senior', array['kaimono','denkyu','hanashi'], array[]::text[]),
 ('ume',   '試験 うめ', 81, 'senior', array['hanashi'], array['denkyu','kaimono']);

-- うめさんの「してほしいこと」を依頼として登録
insert into requests (member_id, need, need_text, when_text)
select id, 'denkyu', '廊下の電球を替えてほしい', '今週中' from members where code='ume';
insert into requests (member_id, need, need_text, when_text)
select id, 'kaimono', '重いお米を買ってきてほしい', '水曜の午前' from members where code='ume';

-- 花子さんの家族(孫・陽菜)
insert into members (code, name, role, family_of)
select 'hina', '試験 陽菜', 'family', id from members where code='sakura';

-- 新しい会員を追加するときの書き方(導入会で使う):
-- insert into members (code, name, age, role) values ('好きな合言葉','氏名',年齢,'senior');
-- 家族を追加するとき:
-- insert into members (code, name, role, family_of)
-- select '合言葉','氏名','family', id from members where code='見守る相手の合言葉';
