# クイズ大会アプリ

[開発について](https://scrapbox.io/programming-technology/Nuxt_+_Vuetify_+_Rails_API_mode%E3%81%A7%E3%82%AF%E3%82%A4%E3%82%BA%E5%A4%A7%E4%BC%9AWeb%E3%82%A2%E3%83%97%E3%83%AA%E3%82%92%E4%BD%9C%E3%82%8B)

## ローカルでの起動
dockerを導入していること

- .env_sampleをコピーして.envという名前で保存
- master.keyをプロジェクト管理者から受け取りapi/config/master.keyに配置

``` bash
make init
```

アプリが起動。
- http://localhost:8000 => service
- http://localhost:8080 => admin

Ctrl + Cで終了

2回目以降
``` bash
make
```

## デプロイ
まず
``` bash
heroku login
```

API, Admin, Serviceの3つのものがデプロイ対象。
これら全てで一度デプロイを済ませれば、あとは
``` bash
make deploy_all
```
で、**DBのリセットを含めた**全てのデプロイを実行する。

### API
`heroku create app`直後ならば、上記「開発について」を参照しながらherokuでの環境変数の設定を先に行うこと。
``` bash
> cd api
> git init
> git remote add heroku https://git.heroku.com/quiz-competition-api.git
> cd ..

2回目以降は次のコマンドのみ
> make deploy_api
```

### 管理画面 (admin)
``` bash
> cd admin
> git init
> git remote add heroku https://git.heroku.com/quiz-competition-admin.git
> cd ..

2回目以降は次のコマンドのみ
> make deploy_admin
```

### サービス画面 (service)
``` bash
> cd service
> git init
> git remote add heroku https://git.heroku.com/quiz-competition-service.git
> cd ..

2回目以降は次のコマンドのみ
> make deploy_service
```

## 心残り
- 機能
  - firebase notificationやOneSignalを使ったWebpushを使った自動進行
  - セッションキーにridつける(そうしないと別の大会参加するときに一回/competition行っちゃう)
  - 同じemailで登録できなかったときやパスワードが短すぎたときのエラー内容
  - クイズ大会中はクイズ集の編集禁止
  - 参加人数とか、クイズ集数、問題数とかの制限
  - クイズ集の作成・名前変更・削除
- コード
  - API
    - Controllerが全体的にFat。RailsAPIの作法を先に勉強しとけばよかった
      - imageは、quizのnullableカラムとして持たせるのではなく、QuestionImage, AnswerImageテーブルとし、それぞれhas_one制約で持たせればよかった
        - null:trueは基本使わないこと！
        - その上で、QuestionImage, AnswerImageはS3ImageHandlerというConcernをincludeすることで、`quiz.question_image.url`のような書き方ができる！
      - JSONとなるハッシュはControllerで作って良いのか？
    - エラーメッセージは最初からlocaleしとくべきだった。フロントでエラーメッセージ書くのめんどい。
    - env, いらなくね？
    - RSpec, rubocop
  - フロント
    - 特定ページの肥大化。コンポーネントを綺麗に分割するのは難しい？
