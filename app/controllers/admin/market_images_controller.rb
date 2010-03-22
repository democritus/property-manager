class Admin::MarketImagesController < Admin::AdminController
  
  before_filter :set_market_imageable
  
  # GET /market_images
  # GET /market_images.xml
  def index
    @market_images = @market_imageable.market_images

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /market_images/new
  # GET /market_images/new.xml
  def new
    @market_image = MarketImage.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /market_images/1/edit
  def edit
    @market_image = MarketImage.find(params[:id]) 
  end

  # POST /market_images
  # POST /market_images.xml
  def create
    @market_image = @market_imageable.market_images.build( params[:market_image] )

    respond_to do |format|
      if @market_image.save
        flash[:notice] = 'MarketImage was successfully created.'
        format.html { redirect_to(
          polymorphic_url([:admin, @market_imageable, :market_images])) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /market_images/1
  # PUT /market_images/1.xml
  def update
    @market_image = MarketImage.find(params[:id])

    respond_to do |format|
      if @market_image.update_attributes(params[:market_image])
        flash[:notice] = 'MarketImage was successfully updated.'
        format.html { redirect_to(
          polymorphic_url([:admin, @market_imageable, :market_images])) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /market_images/1
  # DELETE /market_images/1.xml
  def destroy
    @market_image = MarketImage.find(params[:id])
    @market_image.destroy
    
    # Clear cache    
    expire_image(@market_image)

    respond_to do |format|
      format.html { redirect_to(
        polymorphic_url([:admin, @market_imageable, :market_images])) }
    end
  end
  
  
  private

  # If nested, set parent instance variable
  def set_market_imageable
    unless params[:context_type].nil?
      @market_imageable = context_object( :include => :market_images )
    end
  end
end
