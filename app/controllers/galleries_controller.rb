class GalleriesController < ApplicationController
  layout 'layout', :except => [:rss]
    
  def index
    _load_galleries_and_tags
  end
  
  def show
    gallery = Gallery.find(params[:id])
    
    # check if the url is avaible
    require 'open-uri'
    begin
      open(gallery.permalink)
    rescue
      tag = Gallery.destroy(params[:id]).tag
      Rails.cache.clear
      tag.decrement!(:galleries_count)
      Tag.find_by_name('all').decrement!(:galleries_count)
      render(:text => 'error')
      return
    end
    
    gallery.increment!(:views)
    
  rescue ActiveRecord::RecordNotFound
    render :file => "#{RAILS_ROOT}/public/403.html", :layout => false, :status => 403
  end
  
  def update
    voted = _any_vote?
    if voted && voted[:type] == 'Report'
      voted.update_attribute(:type, 'Milk')
      g = Gallery.find(params[:id])
      g.increment!(:milks)
      g.decrement!(:reports)
    elsif !voted
      Vote.create( :gallery_id => params[:id],
                   :remote_ip => request.remote_ip,
                   :type => 'Milk')
      Gallery.find(params[:id]).increment!(:milks)
    end
    if request.xhr?
      _load_galleries_and_tags
      render(:controller => 'galleries', :action => 'index', :layout => false)
    else 
      redirect_to(:back)
    end
  end
  
  def destroy
    voted = _any_vote?
    if voted && voted[:type] == 'Milk'
      voted.update_attribute(:type, 'Report')
      g = Gallery.find(params[:id])
      g.increment!(:reports)
      g.decrement!(:milks)
    elsif !voted
      Vote.create( :gallery_id => params[:id],
                   :remote_ip => request.remote_ip,
                   :type => 'Report')
      Gallery.find(params[:id]).increment!(:reports)
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
    @current_tag = Tag.find_by_name_and_parent_cached(params[:tag], params[:parent])
    @top_galleries = Gallery.get_all(params[:parent], @current_tag, request, 1)
  end
  
  private
  def _any_vote?
    Vote.find( :first,
               :select => 'id, type',
               :conditions => {:gallery_id => params[:id], :remote_ip => request.remote_ip})
  end
  
  def _load_galleries_and_tags
    @tags = Tag.find_all
    @current_tag = Tag.find_by_name(params[:tag])
    
    if @current_tag
      @galleries = Gallery.find_by_tag(@current_tag, request, params[:page])
      set_paginate(@current_tag.galleries_count)
    end
  end
end
