require 'rubygems'
require 'sinatra'

# anthro product url: 
# http://www.anthropologie.com/anthro/catalog/productdetail.jsp?id=#{sku}

get '/' do
  erb :index
end

get '/less/uber.css' do
  content_type 'text/css', :charset => 'utf-8'
  less :uber
end