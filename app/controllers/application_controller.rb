class ApplicationController < ActionController::Base
  before_filter :get_headers
  
  protect_from_forgery # :secret => 'e2e75db66074953afb794c47aeb9f3f2'
  
  def get_headers
    tag = params[:tag].blank? ? '' : "#{params[:tag].capitalize} - "
    @header_description = "#{tag}Crawlr - Add your description here"
    @header_title = "#{tag}Crawlr - Add your title here!"
  end
  
  protected
  def no_javascript
    @no_javascript = true
  end
    
  def set_paginate(num_results)
    @current_page = params[:page].to_i
    @num_pages = (num_results/(CON::GALLERIES_PER_PAGE).to_f).ceil
    if @current_page <= CON::WINDOW_SIZE
      @first = false
      @first_window = 1
      if @num_pages <= CON::WINDOW_SIZE+3
        @last = false
        @last_window = @num_pages
      else
        @last = true
        @last_window = CON::WINDOW_SIZE+1
      end
    elsif @current_page > @num_pages-CON::WINDOW_SIZE
      @last = false
      @last_window = @num_pages
      if @num_pages <= CON::WINDOW_SIZE+3
        @first= false
        @first_window = 1
      else
        @first= true
        @first_window = @num_pages-CON::WINDOW_SIZE
      end
    else
      @first, @last = true
      @first_window = @current_page-2
      @last_window = @current_page+2
    end
  end
end
