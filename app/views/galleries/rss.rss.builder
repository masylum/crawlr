xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{params[:parent].capitalize}-#{params[:tag].capitalize} Galleries"
    xml.description "Top galleries in this #{params[:parent].capitalize}-#{params[:tag].capitalize} section"
    xml.link galleries_rss_url(:parent => params[:parent], :tag => params[:tag])

    for gallery in @top_galleries
      xml.item do
        xml.title gallery.name
        xml.description "<img src='#{gallery.thumbnail}' alt='#{gallery.name}' />"
        xml.pubDate gallery.created_at.to_s(:rfc822)
        xml.link galleries_show_url(gallery)
      end
    end
  end
end