require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"
require './lib/messages_table'

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @messages_table = MessagesTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
  end

  get "/" do
    messages = @messages_table.all

    erb :home, locals: {messages: messages}
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

  get "/messages/:id/edit" do
    message = @messages_table.find(params[:id])
    erb :"messages/edit", locals: {message: message}
  end

  patch "/messages/:id/patch" do
    @messages_table.update(params[:id], params[:message])
    redirect "/"
  end

end