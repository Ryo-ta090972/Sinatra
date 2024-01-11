require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'json'

enable :method_override

get '/memos' do
  path = File.join(Dir.pwd, 'save_memos.json')
  memos = File.exist?(path) ? JSON.parse(File.read(path)) : {}

  @memos = ''
  memos.each do |title, _|
    @memos = @memos  + "<ul>"
    @memos = @memos + "<li><a href=\"/memos/#{title}\">#{title}</a></li>"
    @memos = @memos + "</ul>"
  end

  erb :memos
end

post '/memos' do
  path = File.join(Dir.pwd, 'save_memos.json')
  memos = File.exist?(path) ? JSON.parse(File.read(path)) : {}
  old_title = params[:old_title]
  new_title = params[:new_title]
  new_content = params[:new_content]

  memos[new_title] = memos.delete(old_title)
  memos[new_title] = new_content
  memos_json = JSON.generate(memos)

  File.open(path, 'w') do |file|
    file.write(memos_json)
  end

  redirect '/memos'
end

delete '/memos' do
  path = File.join(Dir.pwd, 'save_memos.json')
  memos = File.exist?(path) ? JSON.parse(File.read(path)) : {}
  targeted_title = params[:title]
  deleted_memos = memos.delete_if { |title, _| title == targeted_title }
  memos_json = JSON.generate(deleted_memos)
  
  File.open(path, 'w') do |file|
    file.write(memos_json)
  end

  redirect '/memos'
end

get '/memos/:title' do
  path = File.join(Dir.pwd, 'save_memos.json')
  memos = File.exist?(path) ? JSON.parse(File.read(path)) : {}
  title = params[:title]

  if memos.key?(title)
    @title = title
    @content = memos[title]
  end

  erb :show_memos
end

get '/new' do
  erb :new
end

post '/save_memos' do
  path = File.join(Dir.pwd, 'save_memos.json')
  memos = File.exist?(path) ? JSON.parse(File.read(path)) : {}
  memos[params[:title]] = params[:content]
  memos_json = JSON.generate(memos)

  File.open(path, 'w') do |file|
    file.write(memos_json)
  end

  redirect '/memos'
end

get '/edit' do
  path = File.join(Dir.pwd, 'save_memos.json')
  memos = File.exist?(path) ? JSON.parse(File.read(path)) : {}
  title = params[:title]

  if memos.key?(title)
    @title = title
    @content = memos[title]
  end

  erb :edit_memos
end
