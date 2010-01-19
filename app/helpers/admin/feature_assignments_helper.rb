module Admin::FeatureAssignmentsHelper

  def set_feature_assignment_form_list_data
    @lists = {}
    @lists[:features] = Feature.find(:all,
      :include => nil,
      :select => 'id, name'
    ).map {
      |feature| [feature.name, feature.id]
    }
    # Remove from list records already associated with this assignable entity
    unless @feature_assignments.nil?
      feature_assignment_ids = @feature_assignments.map {
        |feature_assignment| feature_assignment.feature_id }
      unless feature_assignment_ids.blank?
        @lists[:features].delete_if {
         |pair| feature_assignment_ids.include?(pair[1]) }
      end
    end
  end
end

