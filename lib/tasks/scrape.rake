require './lib/scraper'
namespace :scrape do
  namespace :anthro do
    desc "scrape anthro's sale items"
    task :sale_items do
      s = Scraper.new
      # will scrape sale items by default
      s.anthro
    end
    
    desc "scrape all anthro items"
    task :items do
      s = Scraper.new
      s.anthro(:category_page=> "http://www.anthropologie.com/anthro/catalog/category.jsp?id=CLOTHES", :item_class=>Item)
    end
  end
end