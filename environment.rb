require 'rubygems'
require 'sinatra/base'
require 'json'
require 'sinatra/activerecord'
require 'warden'
require 'less'
require 'open-uri' # so we can stream the swatch file
require 'chunky_png'
require 'pony'
require 'bcrypt'
require 'extlib'
require 'digest/sha1'
require 'rack-flash'
Dir['./models/*'].each{|m| require m}
Dir['./lib/*.rb'].each{|l| require l}

# require 'dragonfly'
# Dragonfly[:images].configure_with(:rmagick) do |d|
#   d.url_path_prefix = '/media'
# end
# Dragonfly[:images].configure_with(:heroku, 'pleasegoonsale') # if Rails.env.production?
# 
# use Dragonfly::Middleware, :images, '/media'