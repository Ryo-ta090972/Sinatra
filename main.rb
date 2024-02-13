# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'pg'
require 'yaml'

DB_CONFIG_PATH = File.join(File.dirname(__FILE__), 'db', 'db_config.yml')
DB_MEMO_PATH = File.join(File.dirname(__FILE__), 'db', 'db_memo.yml')
TABLE_MEMOS_PATH = File.join(File.dirname(__FILE__), 'db', 'table_memos.sql')
DB_MEMO_NAME = 'db_memo'
TABLE_MEMO_NAME = 'memos'

def main
  build_environment unless is_database
end

get '/memos' do
  @memos = read_memos
  erb :memos
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  id = SecureRandom.uuid
  write_memos(id, title, content)
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
  memos = read_memos
  title = params[:new_title]
  content = params[:new_content]
  id = params[:id]
  update_memos(id, title, content)
  redirect '/memos'
end

delete '/memos/:id' do
  memos = read_memos
  targeted_id = params[:id]
  deleted_memos = memos.except(targeted_id)
  write_memos(deleted_memos)
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
  db_params = YAML.load_file(DB_MEMO_PATH)
  connection = PG.connect(db_params)
  table_memos = connection.exec("SELECT * FROM #{TABLE_MEMO_NAME}")
  transformation_memos = table_memos.each_with_object({}) do |row, new_object|
    new_object[row["id"]] = row.reject { |key| key == "id"}
  end
  connection.close
  transformation_memos
end

def write_memos(id, title, content)
  db_params = YAML.load_file(DB_MEMO_PATH)
  connection = PG.connect(db_params)
  connection.exec_params("INSERT INTO #{TABLE_MEMO_NAME} (id, title, content) VALUES ($1, $2, $3)", [id, title, content])
  connection.close
end

def update_memos(id, title, content)
  db_params = YAML.load_file(DB_MEMO_PATH)
  connection = PG.connect(db_params)
  connection.exec_params("UPDATE #{TABLE_MEMO_NAME} SET title = $2, content = $3 WHERE id = $1", [id, title, content])
  connection.close
end

def read_memos_file_path
  File.join(File.dirname(__FILE__), MEMOS_JSON_FILE)
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def build_environment
  create_database
  create_table
end

def is_database
  db_params = YAML.load_file(DB_CONFIG_PATH)
  connection = PG.connect(db_params)
  exists = connection.exec("SELECT datname FROM pg_database WHERE datname = \'#{DB_MEMO_NAME}\'").num_tuples > 0
  connection.close
  exists
end

def create_database
  db_params = YAML.load_file(DB_CONFIG_PATH)
  connection = PG.connect(db_params)
  connection.exec("CREATE DATABASE #{DB_MEMO_NAME} WITH TEMPLATE = template0 ENCODING 'UTF8'")
  connection.close
end

def create_table
  db_params = YAML.load_file(DB_MEMO_PATH)
  sql_command_for_create_table = File.read(TABLE_MEMOS_PATH).gsub(/\n/, '')
  connection = PG.connect(db_params)
  connection.exec(sql_command_for_create_table)
  connection.close
end

main
