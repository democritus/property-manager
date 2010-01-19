module Admin::CategoryAssignmentsHelper

  def set_category_assignment_form_list_data
    @lists = {}
    @lists[:categories] = Category.find(:all,
      :include => nil,
      :select => 'id, name'
    ).map {
      |category| [category.name, category.id]
    }
    # Remove from list records already associated with this assignable entity
    unless @category_assignments.nil?
      category_assignment_ids = @category_assignments.map {
        |category_assignment| category_assignment.category_id }
      unless category_assignment_ids.blank?
        @lists[:categories].delete_if {
         |pair| category_assignment_ids.include?(pair[1]) }
      end
    end
  end
end

