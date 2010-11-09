class Notify < ActionMailer::Base
  
  # TODO layout template for emails
  
  default :from => "no-reply@pleasegoonsale.com"
  
  def sale_email(user, items)
    @user = user
    @items = items
    set_host
    mail(:to => user.email, :subject => "You've got stuff on sale!")
  end

  def set_host
    # TODO change this to pleasegoonsale.com when the domain is live
    @host = ::Rails.env == 'production' ? 'pleasegoonsale.heroku.com' : 'localhost:3000'
  end
end
