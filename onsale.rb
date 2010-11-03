require 'environment'
 
class OnsaleApp < Sinatra::Base
 
  enable :static, :session, :reload
  set :database, 'sqlite://development.db'
  helpers Sinatra::Auth
  before "/customer*" do
    login_required
  end
  get '/' do
    redirect '/customer'
  end
  
  get '/customer' do
    logged_in?
    @bookmarklet = File.read("#{Dir.pwd}/public/js/bookmarklet.js")
    # @items = Item.all(:price.not => nil)
    @items = Item.all
    erb :index
  end
  
  get "/customer/item/create" do
    item = Item.create(params['item'])
    params["jsonp"] + "(#{item.to_json})"
  end
  
  get '/send_email' do
  end

  #------------
  # User Login
  #------------
  get '/unauthenticated/?' do
    status 401
    user_view :login
  end
  
  post '/unauthenticated/?' do
    status 401
    user_view :login
  end

  get '/login/?' do
    user_view :login
  end
  
  post '/login/?' do
    if env['warden'].authenticate!(:password)
      # TODO drop cookie for bookmarklet
      redirect "/customer"
    else
      user_view :login
    end
  end
  
  get '/logout/?' do
    env['warden'].logout
    redirect '/login'
  end
  
  get '/signup/?' do
    @user = User.new
    user_view :new
  end
  
  post '/signup/?' do
    @user = User.new(params[:user])
    if @user.save
      # TODO send confirm email
      Mailer.mail(:to=>@user.email, :html_body=>user_view(:confirmation))
      redirect "/customer"
    else
      puts @user.errors.inspect
      user_view :new
    end
  end
  
  get '/confirm/:confirmation_code' do
    if User.confirm(params[:confirmation_code])
      redirect "/customer"
    else
      user_view :whoops
    end
  end
  #------------
  # Less CSS
  #------------
  get '/less/uber.css' do
    content_type 'text/css', :charset => 'utf-8'
    less :uber
  end

  get '/less/bookmarklet.css' do
    content_type 'text/css', :charset => 'utf-8'
    less :bookmarklet
  end
  
  
  
end