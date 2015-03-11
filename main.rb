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
      User.create(:user => request[:user].strip, :password => request[:password].strip)
        # :comment => request[:comment].strip,
      #)     
    end
    
    redirect "/dashbord/#{request[:user]}"
  end
end
#login---------------------------------------------
get '/login' do 
  # if session[:user] == params[:user] then
  print session[:user]
  if session[:user] then
    redirect "/dashbord/#{session[:user]}"
  else
    erb :login
  end
end

post '/login' do 
  if User.where(user: request[:user].strip, password: request[:password].strip).first
    session[:user] = request[:user].strip
    redirect "/dashbord/#{request[:user]}"
  else
    erb :login
  end
end
#logout---------------------------------------------
get '/logout' do
  session.delete(:user)
  redirect "/"
end
#dashbord---------------------------------------------
get '/dashbord/?:user?' do |u|
  print session[:user]
  print session[:user]

  if session[:user] == params[:user] then
    @user=params[:user]
    @posts = Post.order("created_at DESC").all

   #   images_name = Dir.glob("public/images/*")
   # @images_path = ''
  
   # images_name.each do |image|
   #   @images_path << image.gsub("public/", "/")
   #  end

    erb :dashbord
  else
    redirect '/login'
  end
end

post '/dashbord/?:user?' do 
     

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
  })
  redirect "/dashbord/#{params[:user]}"
end
#single---------------------------------------------
get '' do 
  erb :single
end
