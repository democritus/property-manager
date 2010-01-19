class Admin::FeaturesController < Admin::AdminController

  before_filter :require_user
  
  # GET /features
  # GET /features.xml
  def index
    @features = Feature.all

    # Values for selects, checkboxes, and radios
    @lists = form_list_data

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /features/1
  # GET /features/1.xml
  def show
    @feature = Feature.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /features/new
  # GET /features/new.xml
  def new
    @feature = Feature.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /features/1/edit
  def edit
    @feature = Feature.find(params[:id])
  end

  # POST /features
  # POST /features.xml
  def create
    # Enable polymorphic behavior
    @feature = context_object( :include => :features ).features.build(params[:feature])

    respond_to do |format|
      if @feature.save
        flash[:notice] = 'Feature was successfully created.'
        format.html { redirect_to :id => nil } # hack to redirect to parent index
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /features/1
  # PUT /features/1.xml
  def update
    @feature = Feature.find(params[:id])

    respond_to do |format|
      if @feature.update_attributes(params[:feature])
        flash[:notice] = 'Feature was successfully updated.'
        format.html { redirect_to(admin_feature_url(@feature)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.xml
  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to(features_url) }
      format.xml  { head :ok }
    end
  end


  private

  def form_list_data
    lists = {}
    lists[:features] = Feature.find(:all).map {
      |feature| [feature.name, feature.id]
    }
    return lists
  end

end
