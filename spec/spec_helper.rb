require "bundler/setup"
Bundler.require(:test)
Dir[ File.join(File.dirname(__FILE__),'..', 'models', '/**/*.rb') ].each{|m| require m}
ENV['RACK_ENV'] ||= 'test'

require 'rspec'
require 'rspec/autorun'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "#{Dir.pwd}/test.db")


Rspec.configure do |config|
  # TODO modularize the transaction setup to work like rspec-rails
  config.before(:each) do
    ActiveRecord::Base.connection.increment_open_transactions
    ActiveRecord::Base.connection.transaction_joinable = false
    ActiveRecord::Base.connection.begin_db_transaction
  end

  config.after(:each) do
    ActiveRecord::Base.connection.rollback_db_transaction
    ActiveRecord::Base.connection.decrement_open_transactions
  end
end

def reset_db
  `rake db:test:prepare`
end

