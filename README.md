使い方

### Docker install
下記からインストール

mac

https://docs.docker.com/docker-for-mac/install/#what-to-know-before-you-install

win

https://docs.docker.com/docker-for-windows/install/

macでhomebrewが入っている場合下記でいけるかも
`$ brew cask install docker`

### Git clone

```
$ git clone https://github.com/shuhei-yamasaki-medpeer/rails-work.git /path/to/work
$ cd /path/to/work
```

### Set domain

./conf/domain.conf 内のexampleを好みのドメインへ書き換えて

/etc/hosts を書き換え

例）test.devでアクセスする時

./conf/domain.conf
```
DNS.1 = example.dev
DNS.2 = *.example.dev
```
exampleを書き換え
```
DNS.1 = test.dev
DNS.2 = *.test.dev
```

/etc/hosts に下記を追記
```
127.0.0.1 test.dev admin.test.dev
```

### Build

アプリケーションディレクトリ作成

```
$ git clone {pumaサーバのrailsアプリケーション} ./src
```

DB設定

データベースは `development` , `test` の名前で自動作成されるのでそれぞれに下記を追加
```
port: 3306
username: root
password: root
host: rails_db
```

Docker Build

```
$ make
```

途中sudoで実行されるので、passwordの入力が必要

### Start

```
$ make up
```

https://test.dev へアクセスできるようになる

### PHP MY ADMIN

http://localhost:18080/


### Mail Catcher

メールブラウザ
http://localhost:1080/


### show routes

```
$ docker-compose run --rm rails_app bundle exec rails routes
```

### こんな時どうする？
#### make時にmaria_dbのbuild時にエラーとなった場合

zoneinfoファイルの参照でエラーとなっている可能性あり

`~/` 以下にzoneinfoのファイルなどをコピーして

docker-composeを下記のように修正すると動くかも

```
/usr/share/zoneinfo/Asia/Tokyo:/etc/localtime:ro
を↓へ書き換え
~/zoneinfo/Asia/Tokyo:/etc/localtime:ro
```

#### bundle installでエラーとなった場合

`bundle install` 実行時に下記のようなエラーが出た場合

```
Could not find autoprefixer-rails-8.0.0 in any of the sources
Run `bundle install` to install missing gems.
```

↓のコマンド実行で動く様になるかも

```
docker volume rm {ディレクトリ名}_rails-bundle-data
```

無くなっていることの確認は下記コマンドで可能

```
docker volume ls
```
