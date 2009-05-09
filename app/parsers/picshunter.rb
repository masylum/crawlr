class Picshunter < Parser
  def parse_gallery(doc)
    (doc/"table.thumbnails/tr/td/a").each do |gallery|
      img = gallery.search('img').first
      name = img.attributes['alt'].to_s
      permalink = 'http://www.pichunter.com'+gallery.attributes['href']
      thumbnail = img.attributes['src'].to_s
      create_gallery(name, permalink, thumbnail)
    end
  end
end

