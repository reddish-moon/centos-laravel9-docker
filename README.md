# centos-laravel9-docker

## 前置きと設定

あくまでも個人的なメモです。
基本Apache License 2.0に準拠します。
ご自由にどうぞ

## Laravel 9

laravelは2022/02/12時点のものでまだbetaです。
開発しやすいようにソースをlaravelディレクトリに配置しています。
vendor配下がないと開発しにくいと思うので、適宜VMから手元にコピーすると良いです。

### サーバ構成とユーザー

windowsで書いて、VMはcentosで動かす
慣れてるのがメンバーが使い慣れてるのがcentosなのでapache-phpもcentosで動かす
ほんとはalpineにしたいが…

ユーザーはVMで使うユーザーと同じにする
Dockerfile内のuserも適宜読み替える

ここではuserで
```
useradd -u 1000 user
```

### 環境分けられるように

とりあえずapache-php/conf.d/www.confに`SetEnv ENV 'dev'`でできるようにしておいた
apacheの環境変数で変えられる
ENVとか使ってdocker-composeから設定等するとちょっとだけ便利になります

### コンテナ、イメージ全削除

テストで沢山使うのでめも
```
docker ps -aq | xargs docker rm
docker images -aq | xargs docker rmi -f
```
