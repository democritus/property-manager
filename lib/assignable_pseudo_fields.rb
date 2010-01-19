module AssignablePseudoFields
  
  def self.included(base_class)
    base_class.class_eval do
      include AssignablePseudoFields::InstanceMethods
      before_save :add_primary_category_to_category_ids,
        :add_primary_style_to_style_ids
      after_save :set_primary_category, :set_primary_style
    end
  end
  
  module InstanceMethods
    def primary_category_id
      if read_attribute(:primary_category_id)
        read_attribute(:primary_category_id).to_i
      else
        category_assignment = self.category_assignments.find(:first,
          :include => nil,
          :conditions => 'primary_category = 1',
          :select => 'category_id'
        )
        return '' if category_assignment.nil?
        category_assignment.category_id
      end
    end
    
    def primary_category_id=(primary_category_id)
      write_attribute(:primary_category_id, primary_category_id.to_i)
    end
        
    def primary_style_id
      if read_attribute(:primary_style_id)
        read_attribute(:primary_style_id).to_i
      else
        style_assignment = self.style_assignments.find(:first,
          :include => nil,
          :conditions => 'primary_style = 1',
          :select => [ :style_id ]
        )
        return '' if style_assignment.nil?
        style_assignment.style_id
      end
    end
    
    def primary_style_id=(primary_style_id)
      write_attribute(:primary_style_id, primary_style_id.to_i)
    end
    
    
    private
    
    def add_primary_category_to_category_ids
      unless self.primary_category_id.blank?
        new_ids = self.category_ids || []
        new_ids << self.primary_category_id
        self.category_ids = new_ids
      end
    end
    
    def set_primary_category
      if self.primary_category_id
        self.transaction do
          # make sure all other records are marked as not primary
          self.category_assignments.update_all(
            { :primary_category => false },
            ['category_id <> ?', self.primary_category_id]
          )
          # make previously associated the primary record
          self.category_assignments.update_all(
            { :primary_category => true },
            ['category_id = ?', self.primary_category_id],
            { :limit => 1 }
          )
        end
      end
    end
    
    def add_primary_style_to_style_ids
      unless self.primary_style_id.blank?
        new_ids = self.style_ids || []
        new_ids << self.primary_style_id
        self.style_ids = new_ids
      end
    end
    
    def set_primary_style
      if self.primary_style_id
        self.transaction do
          # make sure all other records are marked as not primary
          self.style_assignments.update_all(
            { :primary_style => false },
            ['style_id <> ?', self.primary_style_id]
          )
          # make previously associated the primary record
          self.style_assignments.update_all(
            { :primary_style => true },
            ['style_id = ?', self.primary_style_id],
            { :limit => 1 }
          )
        end
      end
    end
  end
end
