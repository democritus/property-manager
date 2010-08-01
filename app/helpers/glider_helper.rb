module GliderHelper

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
  # :trigger_width - width of selector images used to trigger scrolling (pixels)
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
            link_path = listings_options # link to all listings for sale
          elsif parent_model == 'MarketSegment'
            images = object.market_segment_images
            item_class = ' agency'
            link_path = listings_options # link to all listings for sale
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
    
    #panel_count = ((image_count * images_per_object).to_f / size.to_f).ceil
    panel_count = (image_count.to_f / size.to_f).ceil
    
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
    if options['image_width']
      html_options.merge!(:width => options['image_width'])
    end
    if options['image_height']
      html_options.merge!(:height => options['image_height'])
    end
    
    unless image.nil? || image.is_a?(String)
      case options['type']
      when 'large'
        if image.imageable_type == 'Agency'
          path = large_glider_images_agency_image_path(image, :format => :jpg)
        elsif image.imageable_type == 'MarketSegment'
          path = large_glider_images_market_segment_image_path(image,
            :format => :jpg)
        else
          path = large_glider_images_property_image_path(image, :format => :jpg)
        end
      when 'mini'
        if image.imageable_type == 'Agency'
          path = mini_glider_images_agency_image_path(image, :format => :jpg)
        elsif image.imageable_type == 'MarketSegment'
          path = mini_glider_images_market_segment_image_path(image,
            :format => :jpg)
        else
          path = mini_glider_images_property_image_path(image, :format => :jpg)
        end
      else # when 'listing'
        if image.imageable_type == 'Agency'
          path = listing_glider_images_agency_image_path(image, :format => :jpg)
        else
          path = listing_glider_images_property_image_path(image,
            :format => :jpg)
        end
      end
    else
      case image
      when 'recent'
        path = mini_glider_recent_images_property_images_path(:format => :jpg)
        text_overlay = 'Recently viewed listings'
      when 'suggested'
        path = mini_glider_suggested_images_property_images_path(
          :format => :jpg)
        text_overlay = 'Featured listings'
      when 'similar'
        path = mini_glider_similar_images_property_images_path(:format => :jpg)
        text_overlay = 'Similar listings'
      else
        # TODO: Figure out how to build method name from string
        path = send(
          "#{options['type']}_glider_placeholder_images_property_images_path",
          :format => :jpg)
        #path = url_for(
        #  :controller => options['placeholder_controller'],
        #  :action => "#{options['type']}_glider_placeholder",
        #  :format => :jpg
        #)
      end
    end
    
    return image_tag( path, html_options )
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
