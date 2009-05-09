class Booooooom < Parser
  def parse_gallery(doc)
    (doc/"div#left/div.entry/div.post").each do |gallery|
      head = (gallery%'h2/a')
      
      description = (gallery%'div.contentPost/p[1]').inner_html
      name = head.inner_text
      permalink = head.attributes['href']
      image = (gallery%'div.contentPost/p[2] img').attributes['src']
      
      create_gallery(name, description, permalink, image)
    end
  end
end