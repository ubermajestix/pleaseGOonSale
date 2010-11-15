# require './lib/scraper'

desc "cron task for Heroku"
task :cron => :environment do
  s = Scraper.new
  s.anthro(:category_page=> "http://www.anthropologie.com/anthro/catalog/category.jsp?id=CLOTHES", :item_class=>Item)
  s.anthro(:category_page=>"http://www.anthropologie.com/anthro/catalog/category.jsp?id=SHOPSALE", :item_class=>SaleItem)
  user = User.find_by_email("tyler@pleasegoonsale.com")
  user.items = Item.all
  user.save!
  User.find_each do |user|
    # TODO named scope this
    sale_items = user.items.collect{|i| i.sale_item}.uniq.compact
    Notify.sale_email(user,sale_items).deliver
  end
end