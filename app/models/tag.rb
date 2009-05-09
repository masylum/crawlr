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
    find(:all, :conditions => "name != 'all'").each do |t|
      t.update_attribute(:galleries_count, t.galleries.length)
    end
    find(:all, :conditions => "name = 'all'").each do |t|
      t.update_attribute(:galleries_count, sum_counters(["name != 'all'"]))
    end
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
  
  private
  # Sums all the galleries_count of the tags that match the conditions
  def self.sum_counters(conditions)
    find(:all, :conditions => conditions).inject(0) {|sum, n| sum + n.galleries_count }
  end
end
