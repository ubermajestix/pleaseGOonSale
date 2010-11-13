# require './lib/scraper'

desc "cron task for Heroku"
task :cron => :environment do
  s = Scraper.new
  s.anthro(:category_page=> "http://www.anthropologie.com/anthro/catalog/category.jsp?id=CLOTHES", :item_class=>Item)
  s.anthro
  user = User.find_by_email("tyler@pleasegoonsale.com")
  user.items = Item.all
  user.save!
end