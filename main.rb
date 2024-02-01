# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'json'

MEMOS_JSON_FILE = 'saved_memos.json'

get '/memos' do
  @memos = read_memos
  erb :memos
end

post '/memos' do
  memos = read_memos
  uuid = SecureRandom.uuid

  memos[uuid] = {
    title: params[:title],
    content: params[:content]
  }

  write_memos(memos)
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
  id = params[:id]

  memos[id] = {
    title: params[:new_title],
    content: params[:new_content]
  }

  write_memos(memos)
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
  path = read_memos_file_path
  File.exist?(path) ? JSON.parse(File.read(path)) : {}
end

def write_memos(memos)
  path = read_memos_file_path
  memos_json = JSON.generate(memos)
  File.write(path, memos_json)
end

def read_memos_file_path
  File.join(File.dirname(__FILE__), MEMOS_JSON_FILE)
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
