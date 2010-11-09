class Notify < ActionMailer::Base
  
  # TODO layout template for emails
  
  default :from => "no-reply@pleasegoonsale.com"
  
  def sale_email(user, items)
    @user = user
    @items = items
    mail(:to => user.email, :subject => "You've got stuff on sale!")
  end
end
