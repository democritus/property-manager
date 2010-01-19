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
  def self.validates_place_belongs_to_country(attr_name)
    key = attribute.to_s
    # ??? How to get attribute values from record
    return unless self.send(attribute) && self.country_id
    model_name = attribute.humanize.constantize
    place = model_name.find(:first,
      :include => nil,
      :conditions => [
        'id = :x AND country_id = :y',
        [self.send(attribute), self.country_id]
      ]
    )
    unless place
      errors.add(model_name, ' is not located within the selected country')
    end
  end
end

