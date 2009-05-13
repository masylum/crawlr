# ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths += %W( #{RAILS_ROOT}/app/parsers )
    
  config.frameworks -= [:action_mailer ]
  
  config.gem 'rmagick'
  config.gem 'hpricot', :source => "http://code.whytheluckystiff.net"
  config.gem 'haml', :version => '2.1.0'
  
  config.action_controller.session = { :key => "_crawlr_session", :secret => "zemba is an amazing secret key!swine flu!" }
  # config.action_controller.page_cache_directory = "#{RAILS_ROOT}/public/cache"
  # config.cache_store = :file_store, "#{RAILS_ROOT}/tmp/cache"
  # config.action_controller.session_store = :active_record_store
  # config.active_record.schema_format = :sql
end

# CONSTANTS
module CON
  GALLERIES_PER_PAGE = 24
  WINDOW_SIZE = 5
  
  THUMBS_PATH = 'images/thumbs'
  THUMB_WIDTH = 240
  THUMB_HEIGHT = 180
end

ActiveRecord::Base.partial_updates = true

#HAML OPTIONS
#Haml::Template.options = {:escape_html => true,
#                          :ugly => true}
                          
#SASS OPTIONS
#if ENV['RAILS_ENV'] == 'development'
#  Sass::Plugin.options = {:template_location => RAILS_ROOT + "/public/sass",
#                          :style => :compressed,
#                          :always_update => true}
#end

