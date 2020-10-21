# クイズ大会アプリ

[開発について](https://scrapbox.io/programming-technology/Nuxt_+_Vuetify_+_Rails_API_mode%E3%81%A7%E3%82%AF%E3%82%A4%E3%82%BA%E5%A4%A7%E4%BC%9AWeb%E3%82%A2%E3%83%97%E3%83%AA%E3%82%92%E4%BD%9C%E3%82%8B)

## ローカルでの起動
- .env_sampleの値を元に.envを作成し、埋める
- master.keyをapi/config/master.keyに配置

``` bash
make
```

## デプロイ
API, Admin, Serviceの3つのものがデプロイ対象。
これら全てで一度デプロイを済ませれば、あとは
``` bash
make deploy_all
```
で全てのデプロイを実行する。

### API
上記「開発について」を参照しながらherokuでの環境変数の設定を先に行うこと。
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
