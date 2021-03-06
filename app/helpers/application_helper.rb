# Methods added to this helper will be available to all templates in the
# application.
module ApplicationHelper

  include ContextResources
  include HostHelp
  include ReadableSearch
  include RequestPath
  
  def active_agency_logo(agency_logo)
    link_to(
      image_tag(
        images_agency_logo_path( agency_logo, :format => :png )
      ),
      root_path
    )
  end
  
  def default_logo
    image_html = image_tag(
      default_logo_images_agency_path( @active_agency, :format => :png ),
      :border => 0
    )
    link_to image_html, root_path
  end
  
  def all_agencies
    Agency.find(:all)
  end
  
  def remove_listings_without_images!( listings )
    listings.each_index do |i|
      if listings[i].images
        listings.delete_at(i) if listings[i].images.empty?
      else
        listings.delete_at(i)
      end
    end
  end
    
  def spinner( id = 'spinner', class_attribute = ' class=""' )
    '<div' + class_attribute + '>' +
      image_tag('ajax-loader.gif',
        :id => id,
        :style => "display: none"
      ) +
    '</div>'
  end

  # TODO: figure out how to integrate select with text field
  # Build select option list from array (useful with AJAX)
  def auto_select_result(entries, field)
    return unless entries
    return options_for_select(entries, field)
  end  
end
