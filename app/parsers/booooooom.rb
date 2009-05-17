class Booooooom < Parser
  def parse_gallery(page)
    page.search("//div[@class='post']").each do |post|
      head = post.at('h2/a')
      
      description = post.at("div").text
      name = head.text
      permalink = head.attributes['href'].text
      image = post.at("div/p[2]//img").attributes['src'].text
      
      create_gallery(name, description, permalink, image)
    end
  end
end