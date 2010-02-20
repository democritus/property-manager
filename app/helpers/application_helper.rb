# Methods added to this helper will be available to all templates in the
# application.
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
  
  # Sensible defaults for links pointing to listings index page
  def listings_options(params_to_overwrite = {})
    parameters = { :controller => :listings, :action => :index }
    # Constrain "all listings" by agency's primary country by default
    # Having a link with the country name is better for search engines
    unless @active_agency.country.name.blank?
      parameters.merge!(
        'property_barrio_country_name_equals' => @active_agency.country.name
      )
    end
    parameters.merge!('listing_type_name_equals' => 'for sale')
    parameters.merge!(params_to_overwrite)
    
    return verbose_params(parameters)
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
  def multiple_select_html(object_name, type, container, options = {},
                            checkboxes_only = false)
    options[:selected_items] = [] if options[:selected_items].blank?
    if options[:selected_items].empty?
      object = instance_variable_get("@#{object_name}")
      if object
        if object.send("#{type}_ids")
          options[:selected_items] = object.send("#{type}_ids")
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
      '<label for="' + type + '_ids">' + options[:label] + '</label>' +
      multiple_select(
        object_name,
        type + '_ids',
        container,
        options
      )
    else # no object, so assume that only checkboxes are wanted
      checkboxes_for_multiple_select(
        type + '_ids',
        container,
        options[:selected_items],
        options
      )
    end
  end
  
  def checkboxes_for_multiple_select_html( object_name, type, container,
                                           options = {} )
    multiple_select_html( object_name, type, container, options, true )
  end
  
  # Grab ids for multiple select checkboxes from params
  def multiple_select_ids(model_name)
    model_key = model_name.to_sym
    ids_key = "#{model_name}_ids".to_sym
    ids = []
    if params[model_key]
      if params[model_key][ids_key]
        unless params[model_key][ids_key].empty?
          ids = params[model_key][ids_key]
        end
      end
    end
    ids.each_with_index do |value, i|
      ids[i] = value.to_i
    end
    ids.delete_if { |value| value.zero? }
    
    return ids
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
