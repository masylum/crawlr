class FlickrGroup < Parser
  def parse_gallery(page)
    page.search("//p[@class='PoolList']").each do |photo|
      link = photo.at('a')
      
      description = link.attributes['title'].text
      name = photo.search('a')[1].text
      permalink = 'http://www.flickr.com'+link.attributes['href'].text
      image = photo.at('img').attributes['src'].text.gsub(/_t\./, '.')
      
      create_gallery(name, description, permalink, image)
    end
  end
end