require 'rubygems'
require 'sinatra'
require 'json'
require 'dragonfly'
require 'sinatra/activerecord'
require 'less'
require 'open-uri' # so we can stream the swatch file
require 'chunky_png'
  set :static, true

  search_me = ::File.expand_path(::File.join(::File.dirname(__FILE__), 'models', '*.rb'))
  Dir.glob(search_me).sort.each {|rb| require rb}
  
  set :database, 'sqlite://onsale.db'
  
  # Dragonfly[:images].configure_with(:rmagick) do |d|
  #   d.url_path_prefix = '/media'
  # end
  # Dragonfly[:images].configure_with(:heroku, 'pleasegoonsale') # if Rails.env.production?
  # 
  # use Dragonfly::Middleware, :images, '/media'




  get '/' do
    @bookmarklet = File.read("#{Dir.pwd}/public/js/bookmarklet.js")
    # @items = Item.all(:price.not => nil)
    @items = Item.all
    
    erb :index
  end

  get '/less/uber.css' do
    content_type 'text/css', :charset => 'utf-8'
    less :uber
  end

  get '/less/bookmarklet.css' do
    content_type 'text/css', :charset => 'utf-8'
    less :bookmarklet
  end

  get "/customer/item/create" do
    item = Item.create(params['item'])
    params["jsonp"] + "(#{item.to_json})"
  end
  
  post "/sale_item/create" do
    SaleItem.create(JSON.parse(params['item']))
  end
