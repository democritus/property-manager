class Admin::CategoryAssignmentsController < Admin::AdminController

  before_filter :set_category_assignable

  # GET /category_assignments
  # GET /category_assignments.xml
  def index
    @category_assignments = @category_assignable.category_assignments

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # POST /category_assignments
  # POST /category_assignments.xml
  def create
    @category_assignment = @category_assignable.category_assignments.build(
      params[:category_assignment] )

    respond_to do |format|
      if @category_assignment.save
        flash[:notice] = 'Category Assignment was successfully created.'
        format.html { redirect_to(polymorphic_url(
          :admin, [@category_assignable, :category_assignments])) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /category_assignments/1
  # PUT /category_assignments/1.xml
  def update
    @category_assignment = CategoryAssignment.find(params[:id])

    respond_to do |format|
      if @category_assignment.update_attributes(params[:category_assignment])
        flash[:notice] = 'Category Assignment was successfully updated.'
        format.html { redirect_to(polymorphic_url([:admin, @category_assignable,
          :category_assignments])) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /category_assignments/1
  # DELETE /category_assignments/1.xml
  def destroy
    @category_assignment = CategoryAssignment.find(params[:id])
    @category_assignment.destroy

    respond_to do |format|
      format.html { redirect_to(polymorphic_url([:admin, @category_assignable,
        :category_assignments])) }
    end
  end


  private

  # If nested, set parent instance variable
  def set_category_assignable
    unless params[:context_type].nil?
      @category_assignable = context_object( :include => :category_assignments )
    end
  end
end

