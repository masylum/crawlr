class StaticController < ApplicationController
  before_filter :no_javascript
  layout 'layout', :except => [:check_age]
  
  def check_age
  end
  
  def about
  end
  
  def fathers_information
  end
  
  def contact
  end
  
  def legal
    @tags = Tag.find_all_cached_by_parent(params[:parent])
  end
end