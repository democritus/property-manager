class LegacyBase < ActiveRecord::Base
  
  self.abstract_class = true
  establish_connection :legacy
  
  def migrate
    new_record = eval("#{self.class}".gsub(/Legacy/, '')).new(map)
# REMOVED - don't want to keep legacy id, instead store legacy id in new field
# for models where it is desired to save nested records.
#    new_record[:id] = self.id
    new_record.save
  end
  
  
  private
  
  def new_property_id
    Property.find_by_legacy_id(self.PropertyID).id
  end
end
