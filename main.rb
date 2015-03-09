require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

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
  erb :login
end

post '/login' do 
  if User.where(user: request[:user].strip, password: request[:password].strip).first
    session[:user] = request[:user].strip
    redirect "/dashbord/#{request[:user]}"
  else
    erb :login
  end
end
#dashbord---------------------------------------------
get '/dashbord/?:user?' do |u|
  if session[:user] = params[:user] then
    @user=u
    @posts = Post.order("").all
    erb :dashbord
  else
    redirect '/login'
  end
end

post '/dashbord/?:user?' do 
  Post.create({
    :title => request[:title],
    :explain => request[:explain],
    :url => request[:url],
    #:image => request[:image],
    :created_at => Time.now,
  })
  redirect "/dashbord/#{params[:user]}"
end
#single---------------------------------------------
get '/single' do 
  erb :single
end
