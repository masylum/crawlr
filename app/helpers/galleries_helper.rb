module GalleriesHelper
  # TODO: Move to gallery model
  def is_milked?(gallery)
    gallery.milk_ip == request.remote_ip
  end
  
  def is_reported?(gallery)
    gallery.report_ip == request.remote_ip
  end
  
  # TODO: Tie with the parser
  def get_thumbnail(gallery)
    url = "#{CON::THUMBS_PATH}/#{params[:parent]}/#{gallery.id}_#{gallery.name.gsub(/[^A-Za-z0-9_-]/, '')[0..15]}.jpg"
    if File.exist?("public/#{url}") 
      "/#{url}"
    else
      gallery.thumbnail
    end
  end
end
