ActiveRecord::Base.class_eval do
  # TODO: Figure out how to validate that a field's value is present, but only
  # when a set of ids are present from a multiple select field
  def self.validates_presence_of_when(attr_name, dependency, dependency_name)
    unless field_or_ids.blank?
      if attr_name.blank?
        errors.add(attr_name, ' must be selected if ' + dependency_name +
          ' specified')
      end
    end
  end
  
  # TODO: figure out how to validate that place belongs to selected country
  def self.validates_same_parent(
    child_key, parent_name, child_name = nil )
    
    child_name = child_key.humanize
    parent_key = "#{parent_name}_id".to_sym
    
    result = child_name.constantize.find(:first,
      :include => nil,
      :conditions => [
        "id = :x AND #{parent_key} = :y",
        { :x => self.send(child_key), :y => self.send(parent_key) }
      ]
    )
    unless result
      errors.add(child_name, " is not associated with selected #{parent_name}")
    end
  end
end
