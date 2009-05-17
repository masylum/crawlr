desc "Crawl galleries"
task :crawl_galleries => :environment do
  Crawler.suck!
end