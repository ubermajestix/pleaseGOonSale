Warden::Strategies.add(:password) do
  def valid?
    puts "="*45
    puts params
    puts "="*45
    params['email'] && params['password']
  end

  def authenticate!
    puts "="*45
    puts 'auth up!'
    puts "="*45
    u = User.authenticate(params['email'], params['password'])
    u.nil? ? fail!("Could not log you in.") : success!(u)
  end
end