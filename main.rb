# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'pg'
require 'yaml'

DB_CONNECTION_SETTING_FILE = File.join(File.dirname(__FILE__), 'db', 'db_memo.yml')
TABLE_MEMO_NAME = 'memos'

get '/memos' do
  @memos = read_memos
  erb :memos
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  id = SecureRandom.uuid
  insert_memos(id, title, content)
  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = read_memos
  id = params[:id]

  if memos.key?(id)
    @id = id
    @title = memos[id]['title']
    @content = memos[id]['content']
    erb :show_memos
  else
    erb :not_found
  end
end

patch '/memos/:id' do
  title = params[:new_title]
  content = params[:new_content]
  id = params[:id]
  update_memos(id, title, content)
  redirect '/memos'
end

delete '/memos/:id' do
  id = params[:id]
  delete_memos(id)
  redirect '/memos'
end

get '/memos/:id/edit' do
  memos = read_memos
  id = params[:id]

  if memos.key?(id)
    @id = id
    @old_title = memos[id]['title']
    @old_content = memos[id]['content']
    erb :edit_memos
  else
    erb :not_found
  end
end

not_found do
  erb :not_found
end

def read_memos
  connection = PG.connect(db_config)
  table_memos = connection.exec("SELECT * FROM #{TABLE_MEMO_NAME}")
  connection.close
  table_memos.each_with_object({}) do |row, new_object|
    new_object[row['id']] = row.reject { |key| key == 'id' }
  end
end

def insert_memos(id, title, content)
  connection = PG.connect(db_config)
  connection.exec_params("INSERT INTO #{TABLE_MEMO_NAME} (id, title, content) VALUES ($1, $2, $3)",
                         [id, title, content])
  connection.close
end

def update_memos(id, title, content)
  connection = PG.connect(db_config)
  connection.exec_params("UPDATE #{TABLE_MEMO_NAME} SET title = $2, content = $3 WHERE id = $1", [id, title, content])
  connection.close
end

def delete_memos(id)
  connection = PG.connect(db_config)
  connection.exec_params("DELETE FROM #{TABLE_MEMO_NAME} WHERE id = $1", [id])
  connection.close
end

def db_config
  YAML.load_file(DB_CONNECTION_SETTING_FILE)
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
