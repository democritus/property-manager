class Admin::AgencyImagesController < Admin::AdminController

  before_filter :require_user, :only => [:new, :create, :edit, :update,
    :destroy]
  before_filter :set_agency_imageable
  
  caches_page :show
  
  # GET /agency_images
  # GET /agency_images.xml
  def index
    @agency_images = @agency_imageable.agency_images

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /agency_images/new
  # GET /agency_images/new.xml
  def new
    @agency_image = AgencyImage.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /agency_images/1/edit
  def edit
    @agency_image = AgencyImage.find(params[:id])
  end

  # POST /agency_images
  # POST /agency_images.xml
  def create
    @agency_image = @agency_imageable.agency_images.build(
      params[:agency_image])

    respond_to do |format|
      if @agency_image.save
        flash[:notice] = 'AgencyImage was successfully created.'
        format.html { redirect_to(
          polymorphic_url(:admin, [@agency_imageable, :agency_images])) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /agency_images/1
  # PUT /agency_images/1.xml
  def update
    @agency_image = AgencyImage.find(params[:id])

    respond_to do |format|
      if @agency_image.update_attributes(params[:agency_image])
        flash[:notice] = 'AgencyImage was successfully updated.'
        format.html { redirect_to(
          polymorphic_url(:admin, [@agency_imageable, :agency_images])) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /agency_images/1
  # DELETE /agency_images/1.xml
  def destroy
    @agency_image = AgencyImage.find(params[:id])
    @agency_image.destroy

    respond_to do |format|
      format.html { redirect_to(
        polymorphic_url(:admin, [@agency_imageable, :agency_images])) }
    end
  end
  
  
  private

  # If nested, set parent instance variable
  def set_agency_imageable
    unless params[:context_type].nil?
      @agency_imageable = context_object( :include => :agency_images )
    end
  end
end
