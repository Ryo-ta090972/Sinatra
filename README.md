# SinatraでシンプルなWebアプリを作ろう

プラクティス「Sinatra を使ってWebアプリケーションの基本を理解する」の課題提出用のリポジトリです。

課題のメモアプリを作成しましたので、ご確認お願いします。

# 要件

- Ruby 3.2.2+

# 手順
## DBの環境設定
### postgreSQLのインストール

[参考記事](https://lets.postgresql.jp/map/install)を参考に、postgreSQLをインストールする

### userの設定方法

postgreSQLをインストール後、ターミナルで下記コマンドを実行し、ユーザー`memo`を作成する。
```
createuser -P memo
```

このコマンドを実行後、パスワード設定のプロンプトが表示されるので、パスワードを`pass`で設定する。
```
Enter password for new role: pass #このpassはターミナルで表示されない
Enter it again: pass #もう一度passを入力
```

### データベースの作成方法

データベースにアクセスする。
```
sudo -u postgres psql
```

ユーザー名が`memo`でデータベース`db_memo`を作成する。
また、エンコーディングは`UTF8`を指定する。
```
postgres=# CREATE DATABASE db_memo WITH OWNER memo ENCODING 'UTF8' TEMPLATE template0;
```

### テーブルを作成する

`db_memo`のデータベースに移動する。
```
postgres=# \c db_memo
```

テーブル`memos`を作成する。
```
db_memo=# CREATE TABLE Memos (
  id VARCHAR PRIMARY KEY,
  title VARCHAR NOT NULL,
  content VARCHAR NOT NULL,
  UNIQUE (id)
);
```

### 権限を付与する

ユーザー`memo`がテーブル`memos`に対して削除、更新、追加ができるように権限を付与する。
```
db_memo=# GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE memos TO memo;
```

以上でDBの環境設定は完了。

## memoアプリの環境設定

1. 作業PCの任意の作業ディレクトリで`git clone` をしてください。

```
$ git clone -b db https://github.com/自分のアカウント名/memo_app.git
```

2. `memo_app`ディレクトリが作成されますので、`memo_app`ディレクトリに移動してください。

```
$ cd memo_app/
```

3. Bundlerのインストールしてください。

```
$ gem install bundler
```

4. Gemfileの雛形を作成してくだささい。

```
$ bundle init
```

5. Gemfileに下記を記述してください。

```
$ vi Gemfile
```

```
# frozen_string_literal: true

source "https://rubygems.org"

gem "sinatra", "~> 3.1"
gem "sinatra-contrib"
gem "webrick"
gem "pg"

group :development do
  gem 'rubocop-fjord', require: false
  gem 'rubocop-rails', require: false
  gem 'erb_lint', require: false
  gem "debug", ">= 1.0.0"
end
```

6. Gemfileに記述したgemをインストールしてください。

```
$ bundle install --path vendor/bundle
```

7. メモアプリを起動してください。

```
$ bundle exec ruby main.rb
```

※起動した際、下記が表示されますが、何もせずそのまま次の作業に移ってください。

```
== Sinatra (v3.1.0) has taken the stage on 4567 for development with backup from Puma
Puma starting in single mode...
* Puma version: 6.4.0 (ruby 3.2.2-p53) ("The Eagle of Durango")
*  Min threads: 0
*  Max threads: 5
*  Environment: development
*          PID: 23744
* Listening on http://127.0.0.1:4567
* Listening on http://[::1]:4567
Use Ctrl-C to stop

# この画面には触れず手順8を行う
```


8. ブラウザを開いて、メモアプリにアクセスしてください。

```
http://localhost:4567/memos
```

9. アクセス出来たら、メモアプリが利用できます。

# その他

- `rubocop-fjord` の設定方法は[こちら](https://github.com/fjordllc/rubocop-fjord)を参照してください。
- `erb_lint` の設定方法は[こちら](https://github.com/Shopify/erb-lint)を参照してください。

