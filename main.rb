# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'json'

get '/memos' do
  memos = read_memos

  @memos = ''
  memos.each_key do |title|
    @memos += '<ul>'
    @memos += "<li><a href=\"/memos/#{title}\">#{title}</a></li>"
    @memos += '</ul>'
  end
  erb :memos
end

post '/memos' do
  memos = read_memos
  title = sanitize_text(params[:title])
  content = sanitize_text(params[:content])
  memos[title] = content
  write_memos(memos)
  redirect '/memos'
end

patch '/memos' do
  memos = read_memos
  old_title = params[:old_title]
  new_title = sanitize_text(params[:new_title])
  new_content = sanitize_text(params[:new_content])
  memos[new_title] = memos.delete(old_title)
  memos[new_title] = new_content
  write_memos(memos)
  redirect '/memos'
end

delete '/memos' do
  memos = read_memos
  targeted_title = params[:title]
  deleted_memos = memos.delete_if { |title, _| title == targeted_title }
  write_memos(deleted_memos)
  redirect '/memos'
end

get '/memos/:title' do
  memos = read_memos
  title = params[:title]

  if memos.key?(title)
    @title = title
    @content = memos[title]
    erb :show_memos
  else
    erb :not_found
  end
end

get '/new' do
  erb :new
end

get '/edit' do
  memos = read_memos
  title = params[:title]

  if memos.key?(title)
    @title = title
    @content = memos[title]
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

  File.open(path, 'w') do |file|
    file.write(memos_json)
  end
end

def read_memos_file_path
  File.join(Dir.pwd, 'save_memos.json')
end

def sanitize_text(text)
  text.gsub(%r{[<>?/\\]}, '_')
end
