class Tag < ActiveRecord::Base
  #CONSTANTS
  TAGS = %w( all abstract animals architecture art astro black-and-white children fashion landscape others people portraits sport still-lifes street-photo )
    
  #VALIDATIONS
  validates_presence_of :name
  
  # RELATIONSHIPS
  has_many :galleries
  
  #FUNCTIONS
  # update counters after each crawling
  def self.set_counters
    total = 0
    find(:all, :conditions => "name != 'all'", :include => 'galleries').each do |t|
      t.update_attribute(:galleries_count, t.galleries.length)
      total += t.galleries.length
    end
    find(:first, :conditions => "name = 'all'").update_attribute(:galleries_count, total)
  end
    
  # Returns a string for a SQL IN clause
  def self.tag_list_to_sql(array)
    array.collect{|c| "'#{c}'"}*', '
  end
        
  # Get Cached Tags
  def self.find_all()
    Cache::get("all_tags") do
      Tag.find(:all)
    end
  end
  
  def self.find_by_name(name)
    Cache::get("tag_#{name}") do
      Tag.find(:first, :conditions => ['name = ?', name])
    end
  end
end
