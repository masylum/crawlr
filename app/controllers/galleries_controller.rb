class GalleriesController < ApplicationController
  layout 'layout', :except => [:rss]
    
  def index
    _load_galleries_and_tags
  end
  
  def show
    if request.xhr?
      gallery = Gallery.find(params[:id])
      tag = gallery.tag
      
      # check if the url is avaible
      require 'open-uri'
      begin
        open(gallery.permalink)
      rescue
        Gallery.destroy(params[:id])
        Rails.cache.clear
        tag.decrement!(:galleries_count)
        Tag.find_by_name('all').decrement!(:galleries_count)
      end
    
      gallery.increment!(:views)
      
      render :text => gallery.views
    else
      render :file => "#{RAILS_ROOT}/public/403.html", :layout => false, :status => 403
    end
  end
  
  def update
    g = Gallery.find(params[:id])
    voted = g.has_vote?(request.remote_ip)
    g.increment!(:total_votes)
    
    if voted && voted[:type] == 'Report'
      voted.update_attribute(:type, 'Milk')
    elsif !voted
      Vote.create( :gallery_id => params[:id],
                   :remote_ip => request.remote_ip,
                   :type => 'Milk')
    end
    
    if request.xhr?
      _load_galleries_and_tags
      render(:controller => 'galleries', :action => 'index', :layout => false)
    else 
      redirect_to(:back)
    end
  end
  
  def destroy
    g = Gallery.find(params[:id])
    voted = g.has_vote?(request.remote_ip)
    g.decrement!(:total_votes)
    
    if voted && voted[:type] == 'Milk'
      voted.update_attribute(:type, 'Report')
    elsif !voted
      Vote.create( :gallery_id => params[:id],
                   :remote_ip => request.remote_ip,
                   :type => 'Report')
    end    
    
    if request.xhr?
      _load_galleries_and_tags
      render(:controller => 'galleries', :action => 'index', :layout => false)
    else 
      redirect_to(:back)
    end
  end
  
  def create
    call_rake :crawl_galleries
    redirect_to root_path
  end
  
  def rss
    @current_tag = Tag.find_by_name(params[:tag])
    @top_galleries = Gallery.get_all(params[:parent], @current_tag, request, 1)
  end
  
  private  
  def _load_galleries_and_tags
    @tags = Tag.find_all
    @current_tag = Tag.find_by_name(params[:tag])
    
    if @current_tag
      @galleries = Gallery.find_by_tag(@current_tag, request, params[:page])
      set_paginate(@current_tag.galleries_count)
    end
  end
end
