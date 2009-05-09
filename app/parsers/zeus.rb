class Zeus < Parser
  def parse_gallery(doc)
    url = 'http://www.almightyzeus.com/'
    (doc/"//div[@id='galleries_left']/div[@class='galleries']")[0].search("/ul/li").each do |gallery|
      link = (gallery%'a')
      name = link.inner_text
      permalink = url+link.attributes['href'].to_s.gsub('../', '')
      thumbnail = url+link.attributes['onmouseover'].to_s.scan(/"([^"\r\n]*)"/)[0][0].gsub(/"/, '')
      create_gallery(name, permalink, thumbnail)
    end
  end
end