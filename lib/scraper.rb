#!/usr/bin/env ruby

require 'rubygems'
require 'logging'
require 'patron'
require 'open-uri'
require 'nokogiri'
require 'ostruct'
require 'active_record'


class Scraper

  def initialize
    logger.info "Scraping started."
    nil
  end

  def logger
    return @logger if @logger
    Logging.appenders.stdout(:level => :info,:layout => Logging.layouts.pattern(:pattern => '[%c:%5l] %p %d --- %m\n'))
    # TODO need email appender to send error messages
    log = Logging.logger['pleaseGOonSale']
    log.add_appenders 'stdout'
    @logger = log
  end
  
  def start(opts={})
    r = open("http://www.anthropologie.com/anthro/catalog/category.jsp?id=SHOPSALE", "User-Agent" => random_browser_agent)
    if r.status.first.to_i < 400
      doc = Nokogiri::HTML(r.read)
      r.close!
      categories << doc.search('#leftnav-content li a').map{|e| e.get_attribute('href')}.compact.uniq.map{|e| e.match(/(\?|\&)(id\=)(\S+)/)[3]}
      categories.flatten!
      logger.info "got categories"
      download_categories
      logger.info "downloaded categories"
      parse_category_html
      logger.info "parsed category html"
      threaded_parsing
      logger.info "parse #{item_queue.length} items"
      SaleItem.delete_all
      threaded_saving
      logger.info "saved #{SaleItem.count} items"
      
    end
  end
  
  def categories
    @categories ||= []
  end
  
  def category_html_queue
    @category_html_queue ||= Queue.new
  end
  
  def download_categories
    threads = []
    categories.each do |cat|
      threads << Thread.new(cat){|cat_id|
        logger.info "downloading #{cat_id}"
        category_html_queue << open("http://www.anthropologie.com/anthro/catalog/category.jsp?displayNumber=10000&itemCount=10000&id=#{cat_id}", "User-Agent" => random_browser_agent)
      }
    end
    threads.each{|t| t.join}
  end
  
  def category_nokogiri_docs
    @category_nokogiri_docs ||= Queue.new
  end
  
  def item_queue
    @item_queue ||= Queue.new
  end
  
  def parse_category_html
    logger.info(category_html_queue.length)
    while not category_html_queue.empty? do
      html = category_html_queue.pop
      doc = Nokogiri::HTML(html.read)
      doc.css('td').each{|td| category_nokogiri_docs << td }
      html.close!
    end
  end
  
  def threaded_parsing
    threads = []
    # category_nokogiri_docs.each do |html|
    # 2.times do
      # threads << Thread.new(){
        # item_threads = []
        # doc.css('td').each do |e|
        #   item_threads << Thread.new(td){|element|
        while not category_nokogiri_docs.empty? do
            parse_item_and_save(category_nokogiri_docs.pop)
          end
          # }
        # end
        # item_threads.each{|t| t.join}
      # }
    # end
    threads.each{|t| t.join}
  end
  
  def threaded_saving
    threads = []
    # category_nokogiri_docs.each do |html|
    # TODO Threads unreliable - just batch insert with raw sql
    2.times do
      threads << Thread.new(){
        # item_threads = []
        # doc.css('td').each do |e|
        #   item_threads << Thread.new(td){|element|
        while not item_queue.empty? do
          begin
            item_queue.pop.save
          rescue StandardError => e
            logger.error(e)
            logger.error
          end
        end
          # }
        # end
        # item_threads.each{|t| t.join}
      }
    end
    threads.each{|t| t.join}
  end
  
  def parse_item_and_save(element)
    if(element.at_css('div.imageWrapper') && element.at_css('span.PriceAlertText'))
      item = SaleItem.new
      begin
        item.sku                 = element.at_css('div.imageWrapper a').get_attribute('href').match(/(\?|\&)(id\=)(S?\d+)/)[3]
        item.store_url           = "http://www.anthropologie.com/anthro/catalog/productdetail.jsp?&id=" << item.sku
        item.image_url           = element.css('div.colorSelector script').last.inner_html.match(/(http:\/\/\S+)(\?)/)[1]
        item.name                = element.at_css('div.imageWrapper img').get_attribute('title')
        item.raw_sale_price      = element.at_css('span.PriceAlertText').text.strip.inspect
        item.raw_original_price  = element.at_css('span.wasPrice').text.gsub('...was ','')
        item.raw_colors          = []
        element.css('div.colorSelector img').each do |color|
         item.raw_colors << {:swatch_url => color.get_attribute('src'), :name => color.get_attribute('alt')}
        end
        logger.info "saving #{item.inspect}"
        item_queue << item  
      rescue StandardError => e
        logger.error(e)
        logger.error item.inspect if item
      end
    end
  end
  
  def random_browser_agent
    browsers = <<-browsers
    Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.6) Gecko/20070725 Firefox/2.0 Firefox 2.0.0.6, Win XP
    Mozilla/5.0 (Windows; U; Windows NT 6.0; de; rv:1.9.0.15) Gecko/2009101601 Firefox 2.1 (.NET CLR 3.5.30729) Firefox 2.1, Win Vista
    Mozilla/6.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:2.0.0.0) Gecko/20061028 Firefox/3.0 Firefox 3.0, Mac OSX
    Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.0 Firefox 3.0, Win XP
    Mozilla/5.0 (Windows; U; Windows NT 6.1; pl; rv:1.9.1) Gecko/20090624 Firefox/3.5 (.NET CLR 3.5.30729) Firefox 3.5, Win 7
    Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2) Gecko/20100115 Firefox/3.6 Firefox 3.6, Win 7
    Mozilla/5.0 (Windows; U; Windows NT 6.1; pl; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3 Firefox 3.6.3, Win 7
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
    browsers = browsers.split("\n")
    return browsers[rand(browsers.size)]
  end
end
