ENV['DATABASE_URL'] ||= 'postgres://pgos:pgos1!@localhost/pgos'
require 'rake'
require './onsale'
require 'sinatra/activerecord/rake'


puts "="*45
puts ENV['DATABASE_URL']
puts "="*45
Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }