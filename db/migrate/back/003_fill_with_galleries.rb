class FillWithGalleries < ActiveRecord::Migration
  def self.up
    5.times do
      Gallery.create(:name => 'Galeria1', :permalink => 'www.google.com', :thumbnail => "sample.jpg", :type_of => "video")
      Gallery.create(:name => 'Galeria2', :permalink => 'www.yahoo.com', :thumbnail => "sample.jpg", :type_of => "video")
      Gallery.create(:name => 'Galeria3', :permalink => 'www.zemba.com', :thumbnail => "sample.jpg", :type_of => "image")
      Gallery.create(:name => 'Galeria4', :permalink => 'www.doodle.com', :thumbnail => "sample.jpg", :type_of => "image")
      Gallery.create(:name => 'Galeria5', :permalink => 'www.bricomania.com', :thumbnail => "sample.jpg", :type_of => "torrent")
    end
  end

  def self.down
    Gallery.destroy_all
  end
end