class Xnxx < Parser
  def parse_gallery(doc)
    (doc/"html/body/div[@id='content']/table").each do |gallery|
      link = (gallery%'tr:eq(0)/td/a:eq(1)')
      name = (gallery%'tr:eq(1)/td').to_s.scan(/<\/em>\s*.*\s*<strong>/)[0].gsub(/(<\/em>|<strong>)/, '').strip
      permalink = link.attributes['href'].to_s
      thumbnail = (link%'img').attributes['src'].to_s
      create_gallery(name, permalink, thumbnail)
    end
  end
end