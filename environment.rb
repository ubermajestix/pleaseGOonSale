require "bundler/setup"
Bundler.require(:runtime)
# Dir['./models/*'].each{|m| require m}
# Dir['./lib/*.rb'].each{|l| require l}
%w(models lib).each do |path|
  Dir[ File.join(File.dirname(__FILE__), path, '/**/*.rb') ].each do |m|
    require m
  end
end
ENV['DATABASE_URL'] ||= 'postgres://pgos:pgos1!@localhost/pgos'
# require 'dragonfly'
# Dragonfly[:images].configure_with(:rmagick) do |d|
#   d.url_path_prefix = '/media'
# end
# Dragonfly[:images].configure_with(:heroku, 'pleasegoonsale') # if Rails.env.production?
# 
# use Dragonfly::Middleware, :images, '/media'