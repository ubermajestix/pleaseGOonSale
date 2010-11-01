require 'lib/scraper'
namespace :scrape do
  desc "scrape anthro's sale items"
  task :anthro do
    s = Scraper.new
    s.start
  end

end