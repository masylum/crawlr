class Crawler
  def self.suck!
    Gallery.delete_all
    Fail.delete_all
    Vote.delete_all
    
    FileUtils.rm_r('public/images/thumbs') if File.exist? 'public/images/thumbs'
    
    # start the crawling process
    crawl!
    
    Rails.cache.clear
    Tag.set_counters
  end
  
  private
  def self.crawl!
    Booooooom.new('http://www.booooooom.com/sorted/photo/', 'others').get_galleries
    Booooooom.new('http://www.booooooom.com/sorted/photo/page/2/', 'others').get_galleries
    Booooooom.new('http://www.booooooom.com/sorted/photo/page/3/', 'others').get_galleries
    Booooooom.new('http://www.booooooom.com/sorted/photo/page/4/', 'others').get_galleries
    Booooooom.new('http://www.booooooom.com/sorted/photo/page/5/', 'others').get_galleries
  end
end
