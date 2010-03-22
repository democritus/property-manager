class Admin::MarketSegmentImagesController < Admin::AdminController

  before_filter :set_market_segment_imageable
  
  # GET /market_segment_images
  # GET /market_segment_images.xml
  def index
    @market_segment_images = @market_segment_imageable.market_segment_images

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /market_segment_images/new
  # GET /market_segment_images/new.xml
  def new
    @market_segment_image = MarketSegmentImage.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /market_segment_images/1/edit
  def edit
    @market_segment_image = MarketSegmentImage.find(params[:id])
  end

  # POST /market_segment_images
  # POST /market_segment_images.xml
  def create
    @market_segment_image = @market_segment_imageable.market_segment_images.build(
      params[:market_segment_image])

    respond_to do |format|
      if @market_segment_image.save
        flash[:notice] = 'MarketSegmentImage was successfully created.'
        format.html { redirect_to(
          polymorphic_url([:admin, @market_segment_imageable,
            :market_segment_images])) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /market_segment_images/1
  # PUT /market_segment_images/1.xml
  def update
    @market_segment_image = MarketSegmentImage.find(params[:id])

    respond_to do |format|
      if @market_segment_image.update_attributes(params[:market_segment_image])
        flash[:notice] = 'MarketSegmentImage was successfully updated.'
        format.html { redirect_to(
          polymorphic_url([:admin, @market_segment_imageable,
            :market_segment_images])) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /market_segment_images/1
  # DELETE /market_segment_images/1.xml
  def destroy
    @market_segment_image = MarketSegmentImage.find(params[:id])
    @market_segment_image.destroy

    respond_to do |format|
      format.html { redirect_to(
        polymorphic_url(:admin,
          [@market_segment_imageable, :market_segment_images])) }
    end
  end
  
  
  private

  # If nested, set parent instance variable
  def set_market_segment_imageable
    unless params[:context_type].nil?
      @market_segment_imageable = context_object(
        :include => :market_segment_images )
    end
  end
end

