#!/usr/bin/env ruby

require 'rubygems'
require 'logging'
require 'patron'
require 'nokogiri'

class Scraper

  def initialize
    logger.info "Scraping started."
    nil
  end

  def logger
    return @logger if @logger
    Logging.appenders.stdout(:level => :debug,:layout => Logging.layouts.pattern(:pattern => '[%c:%5l] %p %d --- %m\n'))
    # TODO need email appender to send error messages
    log = Logging.logger['pleaseGOonSale']
    log.add_appenders 'stdout'
    @logger = log
  end
  
  def patron
    @patron ||= Patron::Session.new
    @patron.headers["User-Agent"] = random_browser_agent
    @patron.base_url = "http://www.anthropologie.com"
    return @patron
  end
  
  def start(opts={})
    # go to store sale url
    # for anthro: get all sale categories, go to those links and then pull all items
    # use my api endpoint and make a web request with a json blob of data (maybe use workers?)
    
    # get sale categories
    # 61:    r = patron.post("/services/v3/source_commits", xml)
    # http://www.anthropologie.com/anthro/catalog/category.jsp?id=SHOPSALE
    r = patron.get('/anthro/catalog/category.jsp?id=SHOPSALE')
    if r.status < 400
       doc = Nokogiri::HTML(r.body)
       categories = doc.search('#leftnav-content li a').map{|e| e.get_attribute('href')}.compact.uniq.map{|e| m = e.match(/(\?|\&)(id\=)(\S+)/); m[3]}
       puts "="*45
       puts categories.length
       puts "="*45
       category_threads = []
       categories.each do |category|
         category_threads<< Thread.new(category) {|cat_id|
           r = patron.get("/anthro/catalog/category.jsp?viewAllOnOnePage=yes&id=#{cat_id}")
           if r.status < 400
             doc = Nokogiri::HTML(r.body)
           else
             logger.error("#{cat_id} returned #{r.status}")
           end
         }
         #C40D1F
         category_threads.each{|t| t.join}
       end
    else
      logger.error("#{r.base_url} returned #{r.status}")
    end
    
    # "#leftnav-content , li, a"
    # thread out to categories 
    # http://www.anthropologie.com/anthro/catalog/category.jsp?viewAllOnOnePage=yes&id=SHOPSALE-FRESHCUTS
    # threads ||= [] << Thread.new("#{page}00.html", map_area) {|cl_page, map_area|
    # # code...
    # }
    # threads.each{|t| t.join}
    # logger.info ActiveRecord::Base.connection.instance_values["config"].inspect
    # sleep 3
    # @map_areas = opts[:city] ? MapArea.find_all_by_name(opts[:city]) : MapArea.find(:all) 
    # self.logger.info "scraping for #{@map_areas.length} cities"
    # # map_threads = []
    # puts RUBY_VERSION
    #  for map_area in @map_areas.reverse 
    #    # map_threads << Thread.new(map_area){|tmap_area|
    #     tmap_area = map_area
    #     house_start = Time.now
    #     house_count = House.count(:conditions=>{:map_area_id=>tmap_area.id}).to_i 
    #     queue = scrape_links(tmap_area)
    #     pull_down_page(queue, tmap_area)
    #     new_house_count = House.count(:conditions=>{:map_area_id=>tmap_area.id}).to_i
    #     # we only really want to delete houses that aren't coming up in cl search results
    #     mark_old_houses_for_delete(tmap_area.id)
    #     @the_log << "#{timestamp}: Added #{new_house_count - house_count} houses for #{tmap_area.name} took: #{Time.now - house_start}"
    #   # }
    #  end
    #  # map_threads.each{|t| t.join}
    #  JabberLogger.send @the_log.join("\n")
  end
  
  def timestamp
    Time.now.strftime("%H:%M:%S")
  end
  
  def random_browser_agent
    browsers = <<-browsers
    Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.6) Gecko/20070725 Firefox/2.0
    Firefox 2.0.0.6, Win XP
    Mozilla/5.0 (Windows; U; Windows NT 6.0; de; rv:1.9.0.15) Gecko/2009101601 Firefox 2.1 (.NET CLR 3.5.30729)
    Firefox 2.1, Win Vista
    Mozilla/6.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:2.0.0.0) Gecko/20061028 Firefox/3.0
    Firefox 3.0, Mac OSX
    Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.0
    Firefox 3.0, Win XP
    Mozilla/5.0 (Windows; U; Windows NT 6.1; pl; rv:1.9.1) Gecko/20090624 Firefox/3.5 (.NET CLR 3.5.30729)
    Firefox 3.5, Win 7
    Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2) Gecko/20100115 Firefox/3.6
    Firefox 3.6, Win 7
    Mozilla/5.0 (Windows; U; Windows NT 6.1; pl; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3
    Firefox 3.6.3, Win 7
    Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322)
    Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30)
    Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)
    Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; en-GB)
    Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; MS-RTC LM 8)
    Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; en) Opera 8.0
    Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; en) Opera 8.50
    Opera 9.0, Win XP
    Opera 9.2, Win Vista
    Opera 9.4, Win 7
    Opera/9.99 (Windows NT 5.1; U; pl) Presto/9.9.9
    Opera 9.9.9, Win XP
    Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-US) AppleWebKit/530.5 (KHTML, like Gecko) Chrome/ Safari/530.5
    Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/528.8 (KHTML, like Gecko) Chrome/2.0.156.0 Safari/528.8
    Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/531.3 (KHTML, like Gecko) Chrome/3.0.193.0 Safari/531.3
    Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/532.0 (KHTML, like Gecko) Chrome/4.0.202.0 Safari/532.0
    Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/532.0 (KHTML, like Gecko) Chrome/4.0.202.0 Safari/532.0
    Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/532.9 (KHTML, like Gecko) Chrome/5.0.307.1 Safari/532.9
    Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/533.2 (KHTML, like Gecko) Chrome/6.0
    Mozilla/5.0 (iPod; U; CPU iPhone OS 2_2_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Mobile/5H11
    Mozilla/5.0 (Linux; U; Ubuntu; en-us) AppleWebKit/525.13 (KHTML, like Gecko) Version/2.2 Firefox/525.13
    Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_5; en-us) AppleWebKit/525.25 (KHTML, like Gecko) Version/3.2 Safari/525.25
    browsers
    browsers[rand(browsers.size)]
  end
end
