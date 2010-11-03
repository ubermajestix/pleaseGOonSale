Warden::Strategies.add(:password) do
  def valid?
    valid = (params['email'] && params['password']) 
    valid = (params['user']['email'] && params['user']['password']) if !valid and params['user']
    valid
  end

  def authenticate!
    puts "="*45
    puts params.inspect
    puts "="*45
    u = User.authenticate(params['email'], params['password'])
    u = User.authenticate(params['user']['email'], params['user']['password']) if u.nil? && params['user']
    u.nil? ? fail!("Could not log you in.") : success!(u)
  end
end