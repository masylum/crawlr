require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'RMagick'

class Parser
  def initialize(url, tag)
    @url = url
    @tag = Tag.find_by_name(tag).id
  end

  def get_galleries
    open(@url, "Referer" => @url) do |f|
      @response = f.read
    end
    doc = Hpricot(@response, :xhtml_strict => true)
    parse_gallery(doc)
    
  rescue Exception => e
    # TODO: enviar un email
    print e, "\n"
  end

  def parse_gallery(doc)
  end

  protected
  def create_gallery(name, description, permalink, thumbnail)
    g = Gallery.new(:name => name,
                    :description => description.gsub(/<\/?[^>]*>/, ""),
                    :permalink => permalink,
                    :thumbnail => thumbnail,
                    :website => self.class.to_s,
                    :rand_id => rand(1000))
    # Assign tag_id
    g[:tag_id] = @tag
    
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
    blob = open(thumbnail,'rb', "Referer" => @url)
    image = Magick::Image::from_blob(blob.read).first    
    image = image.crop_resized!(CON::THUMB_WIDTH, CON::THUMB_HEIGHT, Magick::NorthGravity)
    image.write("#{dir}/#{id}_#{name.gsub(/[^A-Za-z0-9_-]/, '')[0..15]}.jpg")
  end

  # FAKEEEEEEEEEEEE
  def fake
    # USE IT IN CONSOLE!
    require 'rubygems'
    require 'open-uri'
    require 'hpricot'
    response = ''
    open('http://www.booooooom.com/sorted/photo/', "Referer" => 'http://www.booooooom.com') do |f|
      response = f.read
    end
    doc = Hpricot(response, :xhtml_strict => true)
    
  end
end

