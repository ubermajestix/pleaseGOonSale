require 'environment'
 
class OnsaleApp < Sinatra::Base
 
  enable :static, :session, :reload
  set :database, 'sqlite://development.db'
  
  helpers Sinatra::Auth
  use Rack::Flash
  
  before "/my_rack" do
    login_required
  end
  
  before '*' do
    flash[:notice] = nil
    # puts "="*45
    # puts env.keys.sort
    # puts "="*45
    # puts "="*45
    # puts params.inspect
    # puts "="*45
  end
  
  get '/' do
    erb :index
  end
  
  get '/my_rack' do
    logged_in?
    @bookmarklet = File.read("#{Dir.pwd}/public/js/bookmarklet.js")
    @bookmarklet.gsub!("api_key = ''", "api_key = '#{current_user.confirmation_code}'")
    @bookmarklet.gsub!("host = ''", "host = '#{env['HTTP_HOST']}'")
    user = User.find(current_user.id)
    @items = user.items.reverse
    erb :my_rack
  end
  
  get "/item/create" do
    # TODO items belong_to user
    # user = User.find(params['user_id'])
    u = User.first(:conditions=>{:confirmation_code => params["api_key"]})
    begin
      params['item']['user_id'] = u.id
      item = Item.create!(params['item']) 
      params["jsonp"] + "(#{item.to_json})"
    rescue StandardError => e
      puts e.inspect
      puts e.message.inspect
      params["jsonp"] + "({error: '#{e.message.gsub('Validation failed: Sku ','')}'})"
    end
  end
  
  get '/send_email' do
  end

  #------------
  # User Login
  #------------
  # FIXME is this needed?
  get '/unauthenticated/?' do
    flash[:notice] = "Could not log you in."
    status 401
    user_view :login
  end
  
  post '/unauthenticated/?' do
    flash[:notice] =  "Could not log you in."
    flash[:notice] << " Have you confirmed your account?" if !User.confirmed?(params['email']) 
    status 401
    user_view :login
  end

  get '/login/?' do
    user_view :login
  end
  
  post '/login/?' do
    if env['warden'].authenticate!(:password)
      # TODO drop cookie for bookmarklet?
      redirect "/my_rack"
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
      flash[:notice] = "Check your email to confirm your account"
      redirect "/login"
    else
      puts @user.errors.inspect
      user_view :new
    end
  end
  
  get '/confirm/:confirmation_code' do
    u = User.confirm(params[:confirmation_code])
    if u
      params[:email] = u.email
      flash[:notice] = 'One last step, just login.'
      user_view :login
    else
      flash[:notice] = 'Could not confirm your account.'
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