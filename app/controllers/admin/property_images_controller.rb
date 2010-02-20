class Admin::PropertyImagesController < Admin::AdminController
  
  before_filter :set_property_imageable
  
  caches_page :show
  
  # GET /property_images
  # GET /property_images.xml
  def index
    @property_images = @property_imageable.property_images

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /property_images/new
  # GET /property_images/new.xml
  def new
    @property_image = PropertyImage.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /property_images/1/edit
  def edit
    @property_image = PropertyImage.find(params[:id]) 
  end

  # POST /property_images
  # POST /property_images.xml
  def create
    @property_image = @property_imageable.property_images.build(
      params[:property_image] )

    respond_to do |format|
      if @property_image.save
        flash[:notice] = 'PropertyImage was successfully created.'
        format.html { redirect_to(
          polymorphic_url(:admin, [@property_imageable, :property_images])) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /property_images/1
  # PUT /property_images/1.xml
  def update
    @property_image = PropertyImage.find(params[:id])

    respond_to do |format|
      if @property_image.update_attributes(params[:property_image])
        flash[:notice] = 'PropertyImage was successfully updated.'
        format.html { redirect_to(
          polymorphic_url(:admin, [@property_imageable, :property_images])) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /property_images/1
  # DELETE /property_images/1.xml
  def destroy
    @property_image = PropertyImage.find(params[:id])
    @property_image.destroy
    
    # Clear cache    
    expire_image(@property_image)

    respond_to do |format|
      format.html { redirect_to(
        polymorphic_url(:admin, [@property_imageable, :property_images])) }
    end
  end
  
  
  private

  # If nested, set parent instance variable
  def set_property_imageable
    unless params[:context_type].nil?
      @property_imageable = context_object( :include => :property_images )
    end
  end
end
