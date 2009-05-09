class Frenchcum < Parser
  def parse_gallery(doc)
    (doc/"html/body/center/table/tr/td[3]/table[2]/tr/td/table/tr/td/table/tr").each do |gallery|
      link = (gallery%'td[1]/a')
      name = (gallery%"td[2]/a/font/b/u").inner_text
      permalink = link.attributes['name'].to_s
      thumbnail = (link%"img").attributes['src'].to_s
      create_gallery(name, permalink, thumbnail)
    end
  end
end