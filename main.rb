require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'json'

get '/memos' do
  memos = read_memos

  @memos = ''
  memos.each do |title, _|
    @memos = @memos  + "<ul>"
    @memos = @memos + "<li><a href=\"/memos/#{title}\">#{title}</a></li>"
    @memos = @memos + "</ul>"
  end
  erb :memos
end

post '/memos' do
  memos = read_memos
  memos[params[:title]] = params[:content]
  write_memos(memos)
  redirect '/memos'
end

patch '/memos' do
  memos = read_memos
  old_title = params[:old_title]
  new_title = params[:new_title]
  new_content = params[:new_content]
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
  @title = title
  @content = memos[title]
  erb :show_memos
end

get '/new' do
  erb :new
end

get '/edit' do
  memos = read_memos
  title = params[:title]
  @title = title
  @content = memos[title]
  erb :edit_memos
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
