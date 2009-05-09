class TagGalleries < ActiveRecord::Migration
  def self.up
      Gallery.find_all_by_name('Galeria1').each{|g| g.tag_list = "all, amateur, mature";g.save}
      Gallery.find_all_by_name('Galeria2').each{|g| g.tag_list = "all, asian, black";g.save}
      Gallery.find_all_by_name('Galeria3').each{|g| g.tag_list = "all, group, gay";g.save}
      Gallery.find_all_by_name('Galeria4').each{|g| g.tag_list = "all, lesbian, blowjobs";g.save}
      Gallery.find_all_by_name('Galeria5').each{|g| g.tag_list = "all, teens, softcore";g.save}
  end

  def self.down
    Gallery.find_all_by_name('Galeria1').each{|g| g.tag_list = "";g.save}
    Gallery.find_all_by_name('Galeria2').each{|g| g.tag_list = "";g.save}
    Gallery.find_all_by_name('Galeria3').each{|g| g.tag_list = "";g.save}
    Gallery.find_all_by_name('Galeria4').each{|g| g.tag_list = "";g.save}
    Gallery.find_all_by_name('Galeria5').each{|g| g.tag_list = "";g.save}
  end
end