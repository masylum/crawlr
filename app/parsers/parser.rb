require 'rubygems'
require 'mechanize'
require 'RMagick'

class Parser
  def initialize(url, tag)
    @url = url
    @tag = Tag.find_by_name(tag).id
    @agent = agent = WWW::Mechanize.new
  end

  def get_galleries
    page = @agent.get(@url)
    parse_gallery(page)
    
  rescue Exception => e
    # TODO: enviar un email
    print e, "\n"
  end

  def parse_gallery(doc)
  end

  protected
  def create_gallery(name, description, permalink, thumbnail)
    g = Gallery.new(:name => name,
                    :description => description,
                    :permalink => permalink,
                    :thumbnail => thumbnail,
                    :website => self.class.to_s,
                    :rand_id => rand(1000), 
                    :tag_id => @tag)
    
    # try save or report the error
    if g.save
      save_gallery(thumbnail, name, g.id)      
    else
      Fail.create(:name => name,
                  :permalink => permalink,
                  :thumbnail => thumbnail,
                  :website => self.class.to_s,
                  :error => g.errors.inspect)
    end
  end

  def save_gallery(thumbnail, name, id)
    dir = "public/#{CON::THUMBS_PATH}"
    FileUtils.mkdir_p dir, :mode => 0777 unless File.exist? dir
    
    #resized
    blob = @agent.get(thumbnail)
    image = Magick::Image::from_blob(blob.content).first    
    image = image.crop_resized!(CON::THUMB_WIDTH, CON::THUMB_HEIGHT, Magick::NorthGravity)
    image.write("#{dir}/#{id}_#{name.gsub(/[^A-Za-z0-9_-]/, '')[0..15]}.jpg")
  end

  # FAKEEEEEEEEEEEE
  def fake
    # USE IT IN CONSOLE!
    require 'rubygems'
    require 'mechanize'

    agent = WWW::Mechanize.new
    page = agent.get('http://www.booooooom.com/sorted/photo/page/2/')
    
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

