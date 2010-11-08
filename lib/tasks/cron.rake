# require './lib/scraper'

desc "cron task for Heroku"
task :cron => :environment do
  s = Scraper.new
  # will scrape sale items by default
  s.anthro
end