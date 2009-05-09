class Gallery < ActiveRecord::Base
  
  #CONSTANTS
  NAME_LENGTH_RANGE = 3..100
  
  # NAMED SCOPES
  named_scope :tagged_with, lambda { |tag|
    tag.name != 'all' ? {:conditions => ["tag_id = ?", tag.id]} : {}
  }
  named_scope :enabled, :conditions => {:enabled => true}
  
  #VALIDATIONS
  validates_presence_of :name, :permalink, :thumbnail, :tag_id
  
  validates_length_of :name, :within => NAME_LENGTH_RANGE
  
  validates_numericality_of :views,
                            :rand_id,
                            :initial_votes,
                            :milks,
                            :reports,
                            :only_integer => true,
                            :allow_nil => true
  
  # in performance we trust!
  # validates_uniqueness_of :permalink
  
  validates_inclusion_of :enabled, :in  => [true, false]
    
  # RELATIONSHIPS
  has_many :votes,
           :dependent => :destroy
           
  belongs_to :tag,
             :counter_cache => false
  
  #FUNCTIONS
  def self.find_by_tag(tag, request, page)    
    tagged_with(tag).enabled.find(:all,
       :select => 'galleries.id, galleries.name, galleries.permalink, galleries.thumbnail, galleries.created_at, galleries.description, milks.remote_ip AS milk_ip, reports.remote_ip AS report_ip, (initial_votes+milks-reports) AS total_votes',
       :joins => "LEFT OUTER JOIN votes AS milks ON galleries.id = milks.gallery_id AND milks.remote_ip = '#{request.remote_ip}' AND milks.type = 'milk'
                  LEFT OUTER JOIN votes AS reports ON galleries.id = reports.gallery_id AND reports.remote_ip = '#{request.remote_ip}' AND reports.type = 'report'",
       :offset => CON::GALLERIES_PER_PAGE*(page.to_i-1),
       :limit => CON::GALLERIES_PER_PAGE,
       :order => 'total_votes DESC, rand_id, galleries.id')
  end
end
