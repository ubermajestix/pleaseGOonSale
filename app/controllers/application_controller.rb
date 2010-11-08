class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def build_bookmarklet
    @bookmarklet = File.read("#{Rails.root}/public/javascripts/bookmarklet.js")
    puts "="*45
    puts @bookmarklet.inspect
    puts "="*45
    puts "="*45
    puts current_user.inspect
    puts request.raw_host_with_port
    puts "="*45
    @bookmarklet.gsub!("<-api_key->", current_user.authentication_token)
    @bookmarklet.gsub!("<-host->", request.raw_host_with_port)
    puts "="*45
    puts @bookmarklet.inspect
    puts "="*45
  end
end
