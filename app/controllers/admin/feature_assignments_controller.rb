class Admin::FeatureAssignmentsController < Admin::AdminController
  before_filter :set_feature_assignable

  # GET /feature_assignments
  # GET /feature_assignments.xml
  def index
    @feature_assignments = @feature_assignable.feature_assignments

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # POST /feature_assignments
  # POST /feature_assignments.xml
  def create
    @feature_assignment = @feature_assignable.feature_assignments.build(
      params[:feature_assignment] )

    respond_to do |format|
      if @feature_assignment.save
        flash[:notice] = 'FeatureAssignment was successfully created.'
        format.html { redirect_to(:admin, polymorphic_url([@feature_assignable,
          :feature_assignments])) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /feature_assignments/1
  # PUT /feature_assignments/1.xml
  def update
    @feature_assignment = FeatureAssignment.find(params[:id])

    respond_to do |format|
      if @feature_assignment.update_attributes(params[:feature_assignment])
        flash[:notice] = 'FeatureAssignment was successfully updated.'

        format.html { redirect_to(:admin, polymorphic_url([@feature_assignable,
          :feature_assignments])) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /feature_assignments/1
  # DELETE /feature_assignments/1.xml
  def destroy
    @feature_assignment = FeatureAssignment.find(params[:id])
    @feature_assignment.destroy

    respond_to do |format|
      format.html { redirect_to(:admin, polymorphic_url([@feature_assignable,
        :feature_assignments])) }
    end
  end


  private

  # If nested, set parent instance variable
  def set_feature_assignable
    unless params[:context_type].nil?
      @feature_assignable = context_object( :include => :feature_assignments )
    end
  end
end
