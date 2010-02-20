class Admin::StyleAssignmentsController < Admin::AdminController

  before_filter :set_style_assignable

  # GET /style_assignments
  # GET /style_assignments.xml
  def index
    @style_assignments = @style_assignable.style_assignments

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # POST /style_assignments
  # POST /style_assignments.xml
  def create
    @style_assignment = @style_assignable.style_assignments.build(
      params[:style_assignment] )

    respond_to do |format|
      if @style_assignment.save
        flash[:notice] = 'Style Assignment was successfully created.'
        format.html { redirect_to(polymorphic_url(:admin, [@style_assignable,
          :style_assignments])) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /style_assignments/1
  # PUT /style_assignments/1.xml
  def update
    @style_assignment = StyleAssignment.find(params[:id])

    respond_to do |format|
      if @style_assignment.update_attributes(params[:style_assignment])
        flash[:notice] = 'Style Assignment was successfully updated.'

        format.html { redirect_to(polymorphic_url(:admin, [@style_assignable,
            :style_assignments])) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /style_assignments/1
  # DELETE /style_assignments/1.xml
  def destroy
    @style_assignment = StyleAssignment.find(params[:id])
    @style_assignment.destroy

    respond_to do |format|
      format.html { redirect_to(polymorphic_url(:admin, [@style_assignable,
        :style_assignments])) }
    end
  end


  private

  # If nested, set parent instance variable
  def set_style_assignable
    unless params[:context_type].nil?
      @style_assignable = context_object( :include => :style_assignments )
    end
  end
end

