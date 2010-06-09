class Images::AgencyImagesController < Images::ImagesController
  
  caches_page :show, :thumb, :large_glider, :large_glider_placeholder

  # GET /agency_images/1.png
  def show
    @agency_image = AgencyImage.find(params[:id])

    respond_to do |format|
      format.jpg  # show.jpg.flexi
    end
  end
  
  # Resized images
  ################
  
  # GET /agency_images/123/thumb.jpg
  def thumb
    @agency_image = AgencyImage.find(params[:id])
    respond_to do |format|
      format.jpg  # thumb.jpg.flexi
    end
  end
  
  # GET /agency_images/123/large_glider.jpg
  def large_glider
    @agency_image = AgencyImage.find(params[:id])
    respond_to do |format|
      format.jpg  # large_glider.jpg.flexi
    end
  end
  
  # GET /agency_images/large_glider_placeholder
  def large_glider_placeholder
    respond_to do |format|
      format.jpg  # large_glider_placeholder.jpg.flexi
    end
  end
end
