module Sinatra
  module Auth
    def view(template)
      erb :"#{self.class.to_s.snake_case}/#{template}"
    end
    
    def login_required
      env['warden'].authenticate!(:password) unless logged_in?
    end
    
    def current_user
      User.find(env['warden'].user.id)
    end
    
    def logged_in?
      env['warden'].authenticated?
    end
    
    def user_view(template)
      erb :"user_manager/#{template}"
    end
  end
  helpers Auth
end