class Notify < ActionMailer::Base
  default :from => "no-reply@pleasegoonsale.com"
  
  # TODO template for this
  def sale_email(user, items)
    @user = user
    @items = items
    mail(:to => user.email, :subject => "You've got stuff on sale!", :delivery_method => ::Rails.env=='production' ? :smtp : :file)
  end
end
