# SinatraでシンプルなWebアプリを作ろう

プラクティス「Sinatra を使ってWebアプリケーションの基本を理解する」の課題提出用のリポジトリです。
課題のメモアプリを作成しましたので、ご確認お願いします。

# 要件

- Ruby 3.2.2+
- 作業PCの任意の作業ディレクトリで下記を実行してください。

1. `git clone` をしてください。

```
$ git clone https://github.com/自分のアカウント名/memo_app.git
```

2. Bundlerのインストールしてください。

```
$ gem install bundler
```

3. Gemfileの雛形を作成してくだささい。

```
$ bundle init
```

4. Gemfileに下記を記述してください。

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

5. Gemfileに記述したgemをインストールしてください。

```
$ bundle install --path vendor/bundle
```

6. メモアプリを起動してください。

```
$ bundle exec ruby main.rb
```

7. ブラウザを開いて、メモアプリにアクセスしてください。

```
http://localhost:4567/memos
```

8. アクセス出来たら、メモアプリが利用できます。

# その他

- `rubocop-fjord` の設定方法は[こちら](https://github.com/Shopify/erb-lint)を参照してください。
- `erb_lint` の設定方法は[こちら](https://github.com/fjordllc/rubocop-fjord)を参照してください。

