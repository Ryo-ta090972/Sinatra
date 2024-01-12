# SinatraでシンプルなWebアプリを作ろう

プラクティス「Sinatra を使ってWebアプリケーションの基本を理解する」の課題提出用のリポジトリです。
課題のメモアプリを作成しましたので、ご確認お願いします。

# 要件

- Ruby 3.2.2+

# 手順

1. 作業PCの任意の作業ディレクトリで`git clone` をしてください。

```
$ git clone -b memo https://github.com/自分のアカウント名/memo_app.git
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
gem "puma"
gem "sinatra-contrib"
gem "redcarpet"
gem "webrick"
gem 'rubocop-fjord', require: false
gem 'erb_lint', require: false
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

#何もせず手順8に移行
```


8. ブラウザを開いて、メモアプリにアクセスしてください。

```
http://localhost:4567/memos
```

9. アクセス出来たら、メモアプリが利用できます。

# その他

- `rubocop-fjord` の設定方法は[こちら](https://github.com/fjordllc/rubocop-fjord)を参照してください。
- `erb_lint` の設定方法は[こちら](https://github.com/Shopify/erb-lint)を参照してください。

