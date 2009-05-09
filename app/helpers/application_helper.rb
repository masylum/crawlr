# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # RENDER TABS
  def render_tabs(parent, active=true)
    parents = parent.pluralize
    have_parent = (params[:parent] == parent)
    haml_tag(:li, :class => have_parent ? 'current' : nil) do
      if !active
        haml_tag(:span, :class => 'not_active'){ puts parents }
      elsif have_parent
        haml_tag(:h2){ puts parents }
      else
        haml_tag(:a, :href => galleries_index_url(:parent => parent, :tag => params[:tag]), :title => "We have tons of #{parents} waiting for you!"){ puts parents }
      end
    end
  end
end
