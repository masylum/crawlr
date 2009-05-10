class StaticController < ApplicationController
  before_filter :no_javascript
  layout 'layout', :except => [:check_age]
    
  def about
  end
    
  def contact
  end  
end