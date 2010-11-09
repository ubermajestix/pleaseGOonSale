# require './lib/scraper'

desc "cron task for Heroku"
task :cron => :environment do
  s = Scraper.new
  s.anthro
end