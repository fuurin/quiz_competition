# クイズ大会アプリ

[開発について](https://scrapbox.io/programming-technology/Nuxt_+_Vuetify_+_Rails_API_mode%E3%81%A7%E3%82%AF%E3%82%A4%E3%82%BA%E5%A4%A7%E4%BC%9AWeb%E3%82%A2%E3%83%97%E3%83%AA%E3%82%92%E4%BD%9C%E3%82%8B)

## ローカルでの起動
- .env_sampleの値を元に.envを作成し、埋める
- master.keyをapi/config/master.keyに配置

``` bash
make
```

## デプロイ

### API
herokuでの環境変数の設定
``` bash
> heroku config:set RACK_ENV=production RAILS_ENV=production RAILS_LOG_TO_STDOUT=enabled RAILS_SERVE_STATIC_FILES=enabled RAILS_MASTER_KEY=<master.keyの値> -a quiz-competition-api.git
```

``` bash
> cd api
> git init
> git remote add heroku https://git.heroku.com/quiz-competition-api.git
> cd ..

2回目以降は次のコマンドのみ
> make deploy_api
```

### フロントエンド
``` bash
> cd front
> git init
> git remote add heroku https://git.heroku.com/quiz-competition-web.git
> cd ..

2回目以降は次のコマンドのみ
> make deploy_front
```
