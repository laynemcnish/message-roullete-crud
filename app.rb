require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"
require './lib/messages_table'
require './lib/comments_table'

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @messages_table = MessagesTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
    @comments_table = CommentsTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))

  end

  get "/" do
    messages = @messages_table.all
    comments = @comments_table.all

    erb :home, locals: {messages: messages, comments: comments}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @messages_table.create_message(message)
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  # get "/messages/:id" do
  #   # message = @messages_table.find(params[:id])
  #   # messages = @messages_table.all
  #   comments = @comments_table.all
  #   erb locals: {messages: messages, comments: comments, message: message}
  # end

  get "/messages/:id/show" do
    message = @messages_table.find(params[:id])
    messages = @messages_table.all
    comments = @comments_table.all
    erb :"messages/show", locals: {messages: messages, comments: comments, message: message}
  end


  get "/messages/:id/edit" do
    message = @messages_table.find(params[:id])
    erb :"messages/edit", locals: {message: message}
  end

  get "/comments/:id" do
    message = @messages_table.find(params[:id])
    erb :"messages/comment", locals: {message: message}
  end

  post "/comments/:id" do

    @comments = @comments_table.create_comment(params[:id], params[:comment])

    redirect "/"

  end

  patch "/messages/:id/patch" do
    message = params[:message]
    if message.length <= 140
      @messages_table.update(params[:id], params[:message])
    else
      flash[:error] = "Message must be less than 140 characters."
      redirect "/messages/#{params[:id]}/edit"
    end
    redirect "/"
  end

  delete "/messages/:id" do
    @messages_table.delete(params[:id])
    @comments_table.delete_comment(params[:id])
    flash[:notice] = "Message deleted"
    redirect "/"
  end

  patch "/messages/:id/add_like" do
    original = @messages_table.find_likes(params[:id])
    new_like_num = original["likes"].to_i + 1
    @messages_table.add_like(params[:id], (new_like_num))
    redirect "/"
  end

  patch "/messages/:id/delete_like" do
    original = @messages_table.find_likes(params[:id])
    if original["likes"].to_i > 0
    new_like_num = original["likes"].to_i - 1
    else
    new_like_num = 0
    end
    @messages_table.add_like(params[:id], (new_like_num))
    redirect "/"
  end
end