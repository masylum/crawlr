ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'galleries', :action => 'index', :tag => 'all', :page => '1'
  
  map.contents '/contents/:action', :controller => 'contents'
  
  map.with_options :controller => 'galleries' do |gal|
    gal.galleries_create  '/zemba',                 :action => 'create'
    gal.galleries_update  '/:tag/:page/milk/:id',   :action => 'update', :requirements => { :id => /\d+/, :page => /\d+/}
    gal.galleries_destroy '/:tag/:page/report/:id', :action => 'destroy', :requirements => { :id => /\d+/, :page => /\d+/}
    gal.galleries_show    '/show/:id',              :action => 'show', :requirements => { :id => /\d+/}
    gal.galleries_index   '/:tag/:page',            :action => 'index', :tag => 'all', :page => '1', :requirements => { :page => /\d+/}
    gal.galleries_rss     '/:parent/:tag.:format',  :action => 'rss', :format => 'rss'
  end
end
