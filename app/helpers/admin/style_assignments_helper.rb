module Admin::StyleAssignmentsHelper

  def set_style_assignment_form_list_data
    @lists = {}
    @lists[:styles] = Style.find(:all,
      :include => nil,
      :select => 'id, name'
    ).map {
      |style| [style.name, style.id]
    }
    # Remove from list records already associated with this assignable entity
    unless @style_assignments.nil?
      style_assignment_ids = @style_assignments.map {
        |style_assignment| style_assignment.style_id }
      unless style_assignment_ids.blank?
        @lists[:styles].delete_if {
         |pair| style_assignment_ids.include?(pair[1]) }
      end
    end
  end
end

