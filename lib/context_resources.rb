module ContextResources
  
  def namespace
    controller_parts = params[:controller].split('/')
    if controller_parts.length > 1
      controller_parts.pop
      return controller_parts.join('/')
    else
      return ''
    end
  end
  
  def namespace_prefix
    if namespace.blank?
      ''
    else
      namespace + '_'
    end
  end
  
  def context_name
    params[:context_type].singularize
  end
  
  def context_id
    # Sometimes the record id is a string (due to readable_id plugin), in
    # which case the record id has to be fetched
    id = params["#{ context_name }_id"]
    return nil unless id
    if id.to_i.zero? # Not an integer
      params[:context_type].classify.constantize.find(id).id
    else
      id
    end
  end
  
  def context_object( *finder_options )
    # TODO: derive context object from relationship before performing find
    # EX: market.country instead of country.find(market.country_id)
    #??? parent_name = params[:context_type].classify.constantize
    #??? self.send(parent_name) ||
    params[:context_type].classify.constantize.find( context_id,
      *finder_options )
  end
  
  def context_target(object = nil)
    object = instance_variable_get("@#{nested_name}") if object.nil?
    target = []
    target << namespace.to_sym if namespace
    if params[:context_type]
      target << context_object
    end
    target << object
    if target.length < 2
      target[0]
    else
      target
    end
  end
  
  def nested_name
    params[:controller].split('/').last.singularize
  end
  
  # Navigation links for nested resources
  # Note: these methods use lib/contxtual_resources.rb module
  def contextual_collection_path
    if params[:context_type].blank?
      send(namespace_prefix + nested_name.pluralize + '_path')
    else
      send(namespace_prefix + context_name + '_' + nested_name.pluralize +
        '_path', context_object)
    end
  end
  
  def new_contextual_path
    if params[:context_type].blank?
      send('new_' + namespace_prefix + nested_name + '_path')
    else
      send('new_' + namespace_prefix + context_name + '_' + nested_name +
        '_path', context_object)
    end
  end
  
  def contextual_path(record_or_hash)
    if params[:context_type].blank?
      send(namespace_prefix + nested_name + '_path', record_or_hash)
    else
      send(namespace_prefix + context_name + '_' + nested_name + '_path',
        context_object, record_or_hash)
    end
  end
  
  def edit_contextual_path(record_or_hash)
    if params[:context_type].blank?
      send('edit_' + namespace_prefix + nested_name + '_path', record_or_hash)
    else
      send('edit_' + namespace_prefix + context_name + '_' + nested_name +
        '_path', context_object, record_or_hash)
    end
  end
  
  def context_member_path
    return if params[:context_type].blank?
    send(namespace_prefix + context_name + '_path', context_object)
  end
end
