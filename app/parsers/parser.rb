require 'rubygems'
require 'mechanize'
require 'RMagick'

class Parser
  def initialize(url, tag)
    @url = url
    @tag = Tag.find_by_name(tag).id
    @agent = agent = WWW::Mechanize.new
    @dir = Rails.root.join('public', 'images', 'thumbs')
  end

  def get_galleries
    FileUtils.mkdir_p @dir, :mode => 0777 unless File.exist? @dir
    page = @agent.get(@url)
    parse_gallery(page)
    
  rescue Exception => e
    # TODO: enviar un email
    print e, "\n"
  end

  def parse_gallery(doc)
  end

  protected
  def create_gallery(name, description, permalink, image)
    g = Gallery.new(:name => name,
                    :description => description,
                    :permalink => permalink,
                    :thumbnail => image,
                    :website => self.class.to_s,
                    :rand_id => rand(1000), 
                    :tag_id => @tag)
    
    # try save or report the error
    if g.save
      save_gallery(image, name, g.id)      
    else
      Fail.create(:name => name,
                  :permalink => permalink,
                  :thumbnail => image,
                  :website => self.class.to_s,
                  :error => g.errors.inspect)
    end
  end

  def save_gallery(image, name, id)
    #resized
    blob = @agent.get(image)
    image = Magick::Image::from_blob(blob.content).first    
    image = image.crop_resized!(CON::THUMB_WIDTH, CON::THUMB_HEIGHT)
    image.write(File.join(@dir, "#{id}_#{name.gsub(/[^A-Za-z0-9_-]/, '')[0..15]}.jpg"))
  end

  # FAKEEEEEEEEEEEE
  def fake
    # USE IT IN CONSOLE!
    require 'rubygems'
    require 'mechanize'

    agent = WWW::Mechanize.new
    page = agent.get('http://www.flickr.com/groups/fashionphotographyaward/pool/')
    
    page.search("//p[@class='PoolList']").each do |photo|
      link = photo.at('a')
      
      description = link.attributes['title'].text
      name = photo.search('a')[1].text
      permalink = link.attributes['href'].text
      image = photo.at("img").attributes['src'].text
      
      create_gallery(name, description, permalink, image)
    end
  end
end

