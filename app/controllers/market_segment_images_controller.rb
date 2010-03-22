class MarketSegmentImagesController < ApplicationController
  
  caches_page :show, :large_glider, :mini_glider, :thumb

  # GET /market_segment_images/1
  # GET /market_segment_images/1.xml
  # GET /market_segment_images/1.png
  def show
    @market_segment_image = MarketSegmentImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.jpg  # show.jpg.flexi
    end
  end
  
  # Resized images
  ################
  
  # GET /market_segment_images/123/large_glider.jpg
  def large_glider
    @market_segment_image = MarketSegmentImage.find(params[:id])
    respond_to do |format|
      format.jpg  # large_glider.jpg.flexi
    end
  end
  
  # GET /market_segment_images/123/mini_glider.jpg
  def mini_glider
    @market_segment_image = MarketSegmentImage.find(params[:id])
    respond_to do |format|
      format.jpg  # mini_glider.jpg.flexi
    end
  end
  
  # GET /market_segment_images/123/thumb.jpg
  def thumb
    @market_segment_image = MarketSegmentImage.find(params[:id])
    respond_to do |format|
      format.jpg  # thumb.jpg.flexi
    end
  end
end