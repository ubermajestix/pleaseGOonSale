require 'sinatra/activerecord'

namespace :db do
  desc "Empty the test database"
  task :purge do
    dbfile = File.join(File.dirname(__FILE__),'..', '..', 'test.db') 
    puts "purging #{dbfile}"
    File.delete(dbfile) if File.exist?(dbfile)
  end
  namespace :test do
    desc "Prepare for database for testing"
    task :prepare => "db:purge" do
    # ew gross i know
    ENV['RACK_ENV']='test'
    puts `rake db:migrate`
    # Rake::Task["db:migrate"].execute
    end
  end
end