require './onsale'
use Rack::Session::Cookie
use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = OnsaleApp
end
run OnsaleApp

