class Vote < ActiveRecord::Base
  #CONSTANTS
  TYPES = %w( Milk Report )
  
  #VALIDATIONS
  validates_presence_of :remote_ip, :gallery_id, :type
  
  validates_inclusion_of :type, :in  => TYPES
  
  # RELATIONSHIPS
  belongs_to :gallery
  
  #FUNCTIONS
  private
  # hacking the STI mass-asignment protection
  def attributes_protected_by_default
    default = super
    default.delete self.class.inheritance_column
    default
  end
end