class CategoryAssignment < ActiveRecord::Base
  belongs_to :category
  belongs_to :category_assignable, :polymorphic => true
    
  after_save :enforce_one_primary_category_per_parent
  
  
  private
  
  def enforce_one_primary_category_per_parent
    if self.primary_category
      self.category_assignable.category_assignments.update_all(
        { :primary_category => false },
        [ '`id` <> ?', self.id ]
      )
    end
  end
end

