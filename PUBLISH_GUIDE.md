# 公開手順(まゆこさん用・約1時間)

## 1. GitHubアカウントとリポジトリを作る(15分)

1. https://github.com で無料アカウントを作成
2. 右上「+」→「New repository」
   - Repository name: tokutoku-net
   - Public を選択
   - 「Add a README file」はチェックしない
3. 「uploading an existing file」のリンクを押し、
   このフォルダの中身を全部ドラッグ&ドロップ
   (README.md, PHILOSOPHY.md, LICENSE.md, CONTRIBUTING.md,
    PUBLISH_GUIDE.md, app フォルダ)
4. 「Commit changes」を押す

## 2. デモを無料公開する(10分)

GitHub Pages を使うと、体験デモモードをそのまま公開できます。
1. リポジトリの Settings → Pages
2. Source: 「Deploy from a branch」/ Branch: main / フォルダ: /(root)
3. 数分後、https://あなたのID.github.io/tokutoku-net/app/ で
   デモが開けます(このURLをREADMEに追記すると親切です)

※本接続版(Supabase)のURLは地域ごとに別途 Netlify 等で公開します。
  合言葉制のため、本接続URLはREADMEには載せず、地域内でのみ共有。

## 3. 火種をつくる(いちばん大事)

公開しただけでは人は来ません。順番はこうです。
1. お母様の老人会で小さく使ってみる(座を1つ+仕送り徳)
2. その体験を note などで1本の記事にする
   (「三鷹の娘が、八王子の母に徳を送ってみた」)
3. 記事とGitHubのURLをセットで、Code for Japan の
   Slackコミュニティやイベント(ソーシャルハックデー等)で紹介する
4. 問い合わせが来たら CONTRIBUTING.md を案内する

## 4. 守りの手続き(ご専門の範囲で)

- 「徳徳ネット」の商標出願はお早めに(区分はソフトウェア関連
  第9類・42類あたりが中心になるかと思いますが、釈迦に説法ですね)
- Issues での連絡用に、個人アドレスとは別のメールを用意すると安心です

## 困ったら

GitHubの操作で詰まったら、画面のスクリーンショットを
Claudeに見せてください。一緒に解決します。
