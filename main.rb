require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

set :public, File.dirname(__FILE__) + '/public'

enable :sessions
set :session_secret, 'yamanatsu'

ActiveRecord::Base.establish_connection(
  adapter:  "sqlite3",
  database: "development.sqlite3"
)

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

class User < ActiveRecord::Base
  
end

class Post < ActiveRecord::Base
  def date
    self.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end

#home---------------------------------------------
get '/' do 
  @posts = Post.order("created_at DESC").all
  erb :index
end
#register---------------------------------------------
get '/register' do 
  erb :register
end

post '/register' do
  if request[:user] and request[:password]
    unless User.where(user: request[:user].strip).first

      save_path = "./public/images/#{params[:file][:filename]}"
 
  File.open(save_path, 'wb') do |f|
    p params[:file][:tempfile]
    f.write params[:file][:tempfile].read
    @mes = "アップロード成功"
  end

      User.create({
        :user => request[:user].strip,
        :password => request[:password].strip,
        :image => "/images/#{params[:file][:filename]}",
        :comment => request[:comment],
        })     
    end
    
    redirect "/dashboard/#{request[:user]}"
  end
end
#login---------------------------------------------
get '/login' do 
  # if session[:user] == params[:user] then
  print session[:user]
  if session[:user] then
    redirect "/dashboard/#{session[:user]}"
  else
    erb :login
  end
end

post '/login' do 
  if User.where(user: request[:user].strip, password: request[:password].strip).first
    session[:user] = request[:user].strip
    redirect "/dashboard/#{request[:user]}"
  else
    erb :login
  end
end
#logout---------------------------------------------
get '/logout' do
  session.delete(:user)
  redirect "/"
end
#dashboard---------------------------------------------
get '/dashboard/?:user?' do |u|
  if session[:user] == params[:user] then
    @user = User.where(user: params[:user]).first
    @posts = Post.where(user: params[:user]).order("created_at DESC").all

    erb :dashboard
  else
    redirect '/login'
  end
end

post '/dashboard/?:user?' do 
     

  save_path = "./public/images/#{params[:file][:filename]}"
 
  File.open(save_path, 'wb') do |f|
    p params[:file][:tempfile]
    f.write params[:file][:tempfile].read
    @mes = "アップロード成功"
  end
  Post.create({
    :title => request[:title],
    :explain => request[:explain],
    :url => request[:url],
    :image => "/images/#{params[:file][:filename]}",
    :created_at => Time.now,
    :user => session[:user],
  })
  redirect "/dashboard/#{params[:user]}"
end
#User---------------------------------------------
get '/user/:user' do
    @user = User.where(user: params[:user]).first
    @posts = Post.where(user: params[:user]).order("created_at DESC").all
    erb :userpage
end
#single---------------------------------------------
get '' do 
  erb :single
end
#delete---------------------------------------------
post '/delete' do
  Post.find(params[:id]).destroy
end
