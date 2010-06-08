class Images::MarketImagesController < Images::ImagesController

  caches_page :show, :thumb

  # GET /market_images/1
  # GET /market_images/1.xml
  # GET /market_images/1.jpg
  def show
    @market_image = MarketImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @market_image }
      format.jpg  # show.jpg.flexi
    end
  end
  
  # Resized images
  ################
  
  # GET /market_images/123/thumb.jpg
  def thumb
    @market_image = MarketImage.find(params[:id])
    respond_to do |format|
      format.jpg  # thumb.jpg.flexi
    end
  end
end
