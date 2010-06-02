module MultipleSelectHelper

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
end
