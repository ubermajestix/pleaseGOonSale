require 'rubygems'
require 'sinatra'
require 'json'
require 'dragonfly'
require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
require 'less'
require 'open-uri' # so we can stream the swatch file
require 'chunky_png'
  set :static, true

  search_me = ::File.expand_path(::File.join(::File.dirname(__FILE__), 'models', '*.rb'))
  Dir.glob(search_me).sort.each {|rb| require rb}
  # setup logger before connection is made
  DataMapper::Logger.new(STDOUT, :debug)
  DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/onsale.db")
  # ENV['RACK_ENV'] != 'production' ? DataMapper.auto_migrate! :
  DataMapper.auto_upgrade!
  # DataMapper.setup(:default, "postgres://user:pass@localhost/pleasegoonsale")

  # Dragonfly[:images].configure_with(:rmagick) do |d|
  #   d.url_path_prefix = '/media'
  # end
  # Dragonfly[:images].configure_with(:heroku, 'pleasegoonsale') # if Rails.env.production?
  # 
  # use Dragonfly::Middleware, :images, '/media'




  get '/' do
    @bookmarklet = File.read("#{Dir.pwd}/public/js/bookmarklet.js")
    @items = Item.all(:price.not => nil)
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
    puts "="*45
    puts params.inspect
    puts "="*45
    item = Item.create(params['item'])
    params["jsonp"] + "(#{item.to_json})"
  end
