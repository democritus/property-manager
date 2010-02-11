# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  include ContextResources
  include HostHelp
  include ReadableSearch

  def default_logo
    image_html = image_tag(
      default_logo_agency_path(@active_agency),
      :border => 0
    )
    link_to image_html, root_path
  end
  
  def all_agencies
    Agency.find(:all)
  end
  
  # Make listings URL that is keyword rich and compatible with advanced caching
  def cacheable_listings_path( parameters = {} )
    parameters.merge!(verbose_params(parameters)) unless parameters.empty?
    parameters.merge!(:controller => :listings, :action => :index)
    url_for(parameters)
  end      
     
  # Searchlogic conditions with active agency's country
  def agency_country_searchlogic_params
    # Constrain "all listings" by agency's primary country by default
    # Having a link with the country name is better for search engines
    # Compare:
    # http://myagency.com/real_estate?search=Costa+Rica--property--for+sale
    # http://myagency.com/real_estate?search=All--property--for+sale
    unless @active_agency.country.name.blank?
      { 'property_barrio_country_name_equals' => @active_agency.country.name }
    else
      {}
    end
  end
  
  # Make params more human readable and keyword-rich so that URLs are better
  # for search engines
  # (reverse of this is "ApplicationController::sparse_params")
  def verbose_params(parameters = nil)
    if parameters.nil?
      parameters = params.dup
    end
    LISTING_PARAMS_MAP.each do |param|
      if parameters[param[:key]]
        unless parameters[param[:key]] == default_value
          case key
            # Slice off "under " and " dollars"
            when :ask_amount_less_than_or_equal_to
              parameters[param[:key]] = 'under ' + params[key] + ' dollars'
            # Slice off "over " and " dollars"
            when :ask_amount_greater_than_or_equal_to
              parameters[param[:key]] = 'over ' + params[key] + ' dollars'
          end
        end
      else
        # All possible listings
        parameters.merge!(param[:key] => param[:default_value])
      end
    end
    return parameters
  end
  
  # Root path with default search conditions
  def better_listings_path
    constraint = { 'listing_type_name_equals' => 'for sale' }
    constraint.merge!(agency_country_searchlogic_params)
    readable_listings_path(constraint)
  end
    
  def spinner( id = 'spinner', class_attribute = ' class=""' )
    '<div' + class_attribute + '>' +
      image_tag('ajax-loader.gif',
        :id => id,
        :style => "display: none"
      ) +
    '</div>'
  end
  
  # Automatically include LabellingFormBuilder into form_for block
  def labelled_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    form_for(record_or_name_or_array,
      *(args << options.merge(:builder => LabellingFormBuilder)), &proc)
  end
  
  # Build multiple selects and facilitate replacing checkboxes via javascript
  def multiple_select_html(object_name, type, container,
  selected_items = [], options = {}, checkboxes_only = false)
    if selected_items
      object = instance_variable_get("@#{object_name}")
      if object
        if object.send("#{type}_ids")
          selected_items = object.send("#{type}_ids")
        end
      end
    end
    options.merge!(
      :outer_class => 'multiple_select',
      :inner_class => 'multiple_select_checkbox'
    )
    if options[:label].blank?
      options[:label] = type.pluralize.humanize
    end
    unless options[:empty].blank?
      if container.empty?
        container = [[options[:empty], '']]
      end
    end
    unless checkboxes_only
      unless selected_items.empty?
        options.merge!(:selected_items => selected_items)
      end
      '<label for="' + type + '_ids">' + options[:label] + '</label>' +
      multiple_select(
        type,
        type + '_ids',
        container,
        options
      )
    else # no object, so assume that only checkboxes are wanted
      checkboxes_for_multiple_select(
        type + '_ids',
        container,
        selected_items,
        options
      )
    end
  end
  
  def checkboxes_for_multiple_select_html(object_name, type, container,
  selected_items = [], options = {})
    multiple_select_html(
      object_name, type, container, selected_items, options, true)
  end
  
  # Merge Property Images with Listing Images
  def merge_images!(listing = nil)
    listing = @listing unless listing
    listing.images = listing.property_images.dup
    if listing.property
      if listing.property.property_images
        if listing.images
          listing.images += listing.property.property_images
        else
          listing.images = listing.property.property_images
        end
      end
    end
  end

  # TODO: figure out how to integrate select with text field
  # Build select option list from array (useful with AJAX)
  def auto_select_result(entries, field)
    return unless entries
    return options_for_select(entries, field)
  end
  
  #
  # Image Glider
  #
  
  # Create JavaScript object for image glider
  # *options:
  # :name - name of Javascript glider object, used as "id" parameter in HTML
  # :source - array of objects, either images or an object that contains images
  # :size - number of images that should appear per glider panel
  # :image_width - width of one image
  # :image_height - height of one image
  # :images_per_object - extract this many images for each object (if passing
  #   object that contains images
  #   default = 1
  def glider_js(name, source, options = {})
    size = options['size']
    image_width = options['image_width']
    image_height = options['image_height']
    images_per_object = options['images_per_object'] || 1
    total_image_count = 0
    # Loop through to figure out count. Placeholder (nil) and image objects
    # take up one slot, but objects containing images may take up multiple
    # slots (determined by "images_per_object")
    source.each do |object|
      if object.nil?
        total_image_count += 1
      elsif ! object.is_a?(String)
        if object.class.class_name == 'Image'
          total_image_count += 1
        else
          total_image_count += images_per_object
        end
      end
    end
    object_js = 'var ' + name + ' = new Glider(\'' + 
      name + '_panel\', ' + total_image_count.to_s + ', ' +
      image_width.to_s + ', ' + size.to_s + ');'
    html = ''
    #html += '<div id="#{name}_debug">&nbsp;</div>' # Uncomment to debug
    html += javascript_tag(object_js)
  end
  
  # Output HTML for image glider
  # *options
  # :name - name of Javascript glider object, used as "id" parameter in HTML
  # :source - array of objects, either images or an object that contains images
  # :size - number of images that should appear per glider panel
  # :image_width - width of one image
  # :image_height - height of one image
  # :images_per_object - extract this many images for each object (if passing
  #   object that contains images
  #   default = 1
  # :trigger_width - width of selector images used to initiate scrolling (pixels)
  #   default = 20
  # :top_padding - offset trigger to account for dropshadow (top & left)
  #   default = 12
  # :bottom_padding - offset trigger to account for dropshadow (bottom & right)
  #   default = 16
  # :target_id - HTML "id" of element referenced by onclick event
  #   default = nil
  def glider_html(name, source, options = {})
    source = [nil] if source.length.zero? # force one nil value if nothing in
                                          # array to force placeholders
    size = options['size']
    image_width = options['image_width']
    image_height = options['image_height']
    images_per_object = options['images_per_object'] || 1
    trigger_width = options['trigger_width'] || 20
    top_padding = options['top_padding'] || 12
    bottom_padding = options['bottom_padding'] || 16
    scroller_padding = 5
    target_id = options['target_id'] || nil
    unless options['placeholder_controller']
      options['placeholder_controller'] = 'property_images'
    end
    if options['type']
      item_class = ' ' + options['type']
    else
      item_class = ''
    end
    
    return '' if size == 0 # No images
    
    window_width = size * image_width
    right_trigger_spacing = window_width - bottom_padding - trigger_width - scroller_padding
    trigger_height = image_height - top_padding - bottom_padding
    content = ''
    child_offset = 0
    image_count = 0
    text_overlay = ''
    source.each do |object|
      # Insert generic placeholder image if nil, or specific placeholder
      # specified by a string
      if object.nil?
        content += glider_placeholder(nil, options)
        image_count += 1
      elsif object.is_a?(String) # Indicates text overlay for next image
        text_overlay = object
      else
        text_overlay_div = ''
        unless text_overlay.blank?
          text_overlay_div = '<div class="text_overlay">' +
            text_overlay +
          '</div>' +
          '<div class="text_overlay_shadow">' +
            text_overlay +
          '</div>' +
          '<div class="text_overlay_background">' +
            '&nbsp;' +
          '</div>'
          text_overlay = ''
        end
        html_options = {}
        if object.class.class_name == 'Image'  
          if target_id
            html_options = {:onclick => glider_image_swap(object, target_id)}
          end
          content += "<div class=\"glide-item" + item_class + "\">\n"
          content += text_overlay_div
          content += glider_image(object, options, html_options)
          content += "</div>\n"
          image_count += 1
        # Object containing images, append
        else
          link_path = object # default linking to object
          parent_model = object.class.name
          if parent_model == 'Listing'
            merge_images!(object)
            images = object.images
            if options['type'] == 'large'
              item_class = ' large_listing'
              text_overlay_div = '<div class="text_overlay">' +
                object.name +
              '</div>' +
              '<div class="text_overlay_shadow">' +
                object.name +
              '</div>' +
              '<div class="text_overlay_background">' +
                '&nbsp;' +
              '</div>'
            end
          elsif parent_model == 'Agency'
            images = object.agency_images
            item_class = ' agency'
            link_path = readable_listings_path( # link to all listings for sale
              'listing_type_name_equals' => 'for sale')
          else
            images = object.property_images
          end
          child_offset = 0
          while child_offset < images_per_object
            content += "<div class=\"glide-item" + item_class + "\">\n"
            if child_offset.zero?
              content += text_overlay_div
            end
            if images[child_offset]
              image = images[child_offset]
            else
              image = nil
              if parent_model == 'Listing'
                options['placeholder_controller'] = 'property_images'
              else
                options['placeholder_controller'] = 'agency_images'
              end
            end
            content += link_to(glider_image(image, options), link_path)
            content += "</div>\n"
            child_offset += 1
            image_count += 1
          end
        end
      end
    end
    
    # Add placeholder images
    if options['image_placeholders']
      # Count number of empty spaces in case placeholder images should be added
      empty_spaces = size - image_count % size
      if empty_spaces > 0
        empty_spaces.downto(1) do
          content += glider_placeholder(nil, options)
        end
      end
    end
    
    panel_count = ((image_count * images_per_object).to_f / size.to_f).ceil
    html = %Q{
      <div class="glide-holder"
      style="width: #{window_width.to_s}px;
      height: #{image_height.to_s}px">\n
    }
    if panel_count > 1
#      html += %Q{
#        <div class="scroll-right"
#        style="height: #{trigger_height.to_s}px;
#          left: #{right_trigger_spacing.to_s}px"
#        onclick="#{name}.shiftLeft()"></div>\n
#        <div class="scroll-left"
#        style="height: #{trigger_height.to_s}px"
#        onclick="#{name}.shiftRight()"></div>\n
#      }
      html += %Q{
        <div class="scroll-right"
        style="left: #{right_trigger_spacing.to_s}px"
        onclick="#{name}.shiftLeft()"></div>\n
        <div class="scroll-left"
        onclick="#{name}.shiftRight()"></div>\n
      }
    end
    html += %Q{
      <div class="glide-window"
      style="width: #{window_width.to_s}px;
      height: #{image_height.to_s}px;
      clip: rect(0px, #{window_width.to_s}px, 
      #{image_height.to_s}px, 0px)">\n
        <div id="#{name}_panel"
        style="width: #{(window_width*panel_count).to_s}px;
        height: #{image_height.to_s}px">\n
    }
    html += content
    html += %Q{
        </div>\n
      </div>\n
    </div>\n
    }
  end
  
  def glider_image(image = nil, options = {}, html_options = {})
    html_options.merge!(:width => options['image_width']) if options['image_width']
    html_options.merge!(:height => options['image_height']) if options['image_height']
    
    unless image.nil? || image.is_a?(String)
      case options['type']
      when 'large'
        if image.imageable_type == 'Agency'
          path = large_glider_agency_image_path(image, :format => :jpg)
        else
          path = large_glider_property_image_path(image, :format => :jpg)
        end
      when 'mini'
        if image.imageable_type == 'Agency'
          path = mini_glider_agency_image_path(image, :format => :jpg)
        else
          path = mini_glider_property_image_path(image, :format => :jpg)
        end
      else # when 'listing'
        if image.imageable_type == 'Agency'
          path = listing_glider_agency_image_path(image, :format => :jpg)
        else
          path = listing_glider_property_image_path(image, :format => :jpg)
        end
      end
    else
      case image
      when 'recent'
        path = url_for(:controller => 'property_images',
          :action => 'mini_glider_recent')
        text_overlay = 'Recently viewed listings'
      when 'suggested'
        path = url_for(:controller => 'property_images',
          :action => 'mini_glider_suggested')
        text_overlay = 'Featured listings'
      when 'similar'
        path = url_for(:controller => 'property_images',
          :action => 'mini_glider_similar')
        text_overlay = 'Similar listings'
      else
        path = url_for(:controller => options['placeholder_controller'],
          :action => "#{options['type']}_glider_placeholder")
      end
    end
    
    return image_tag(path, html_options)
  end
  
  # Insert nil value instead of image path to indicate placeholder image
  def glider_placeholder(object, options = {}, text_overlay = '')
    "<div class=\"glide-item\">\n" +
      glider_image(object, options, {'class' => 'placeholder'}) +
    "</div>\n"
  end
  
  # Make sure number of images will fill up desired size of glider, if not
  # shrink glider dimensions to fit image count
  def glider_shrink_to_fit(length, options)
  
    images_per_object = options['images_per_object'] || 1
    image_count = length * images_per_object
    
    if image_count < options['size']
      return image_count
    else
      return options['size']
    end
  end
end


# Customize FormBuilder's output
class LabellingFormBuilder < ActionView::Helpers::FormBuilder
  
  def check_box(attribute, options={})
    super + apply_label(attribute, options)
  end
  
  def date_select(attribute, options={})
    apply_label(attribute, options) + super
  end
  
  def datetime_select(attribute, options={})
    apply_label(attribute, options) + super
  end
  
  #def radio_button(attribute, tag_value, options={})
  #  super + apply_label(attribute, options)
  #end
  
  def radio_buttons_from_list(attribute, choices, options={})
    choices.each_with_index do |choice, i|
      result += radio_button(attribute, choice[1], { :label_text => choice[0] })
    end
    return result || ''
  end
  
  def select(attribute, choices, options={}, html_options={})
    apply_label(attribute, options) + super
  end
  
  def text_area(attribute, options={})
    # Change default number of rows
    if options[:rows].blank?
      options[:rows] = 6
    end
    apply_label(attribute, options) + super
  end
  
  def text_field(attribute, options={})
    apply_label(attribute, options) + super
  end
  
  def password_field(attribute, options={})
    apply_label(attribute, options) + super
  end
  
  private
  
  # Apply label to field
  def apply_label(attribute, options={})
    label_text = nil
    # Allow custom label_text to be passed in field's options hash
    if options.include?(:label_text)
      label_text = options[:label_text]
    end
    label(attribute, label_text)
  end
  
  #def apply_radio_label(attribute, value) 
    #label(attribute, label_text)
    #value.to_s
    #label_tag(modelname_attributename_tagvalue, tagvalue)
    #classify.constantize
  #end
end
