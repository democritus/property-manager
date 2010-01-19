class StyleAssignment < ActiveRecord::Base
  belongs_to :style
  belongs_to :style_assignable, :polymorphic => true
  
  after_save :enforce_one_primary_style_per_parent
  
  
  private
  
  def enforce_one_primary_style_per_parent
    if self.primary_style
      self.style_assignable.style_assignments.update_all(
        { :primary_style => false },
        [ '`id` <> ?', self.id ]
      )
    end
  end
end

