require 'sinatra'
require 'sinatra/activerecord'

enable :sessions

set :database, {adapter: "sqlite3", database: "article.sqlite3"}

class User < ActiveRecord::Base
end

class Blog < ActiveRecord::Base
end

get '/' do
  p session
  erb :home
end

# BLOGS

get "/blogs/blog" do
  if session['user_id'] == nil
    p 'User was not logged in'
    redirect '/'
  end
  erb :"blogs/blog"
end

post "/blogs/blog" do
  @blog = Blog.new(title: params[:title], content: params[:content], user_id: params[:user_id])
  @blog.save
  p @blog

  redirect "/blogs/#{@blog.id}"
end

get "/blogs/allblogs" do
@blogs = Blog.all
erb :'/blogs/allblogs'
end

get "/blogs/:id" do
  @blog =  Blog.find(params["id"])
  erb :"/blogs/view-blog"
end

get '/blogs/?' do
  @blogs = Blog.all
  erb:"/blogs/allblogs"
end

post "/blogs/:id" do
  @blog =  Blog.find(params["id"])
  @blog.destroy
  redirect "/blogs/"
end

# LOG IN PAGE

get '/login' do
  erb :'/users/login'
end

post '/login' do
  p params
  user = User.find_by(email: params['email'])
  if user != nil
    if user.password == params['password']
      session[:user_id] = user.id
      redirect "/users/#{user.id}"
    end
  end
end



# LOG OUT

get "/logout" do

  session["user_id"] = nil
  redirect "/"
end

post "/logout" do

  session["user_id"] = nil
  redirect "/"
end

# SIGN UP PAGE

get "/users/signup" do
  if session['user_id'] != nil
    p "User already logged in"
    redirect "/"
  else
    erb :'/users/signup'
  end
end

post "/users/signup" do
  @user =  User.new(first_name: params[:first_name],last_name: params[:last_name], email: params[:email], birthday: params[:birthday], password: params[:password])
  @user.save
  session[:user_id] = @user.id
  redirect "/users/#{@user.id}"
end

# PROFILE

get "/users/:id" do
  @user =  User.find(params["id"])
  erb :"/users/profile"
end

post "/users/:id" do
  @user =  User.find(params["id"])
  @user.destroy
  redirect "/"
end
