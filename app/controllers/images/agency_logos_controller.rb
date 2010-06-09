class Images::AgencyLogosController < Images::ImagesController
  
  caches_page :show, :thumb
  
  def show
    @agency_logo = AgencyLogo.find(params[:id])

    respond_to do |format|
      format.png  # show.png.flexi
    end
  end
  
  # Resized images
  ################
  
  # GET /agency_logos/123/thumb.jpg
  def thumb
    @agency_logo = AgencyLogo.find(params[:id])
    respond_to do |format|
      format.jpg  # thumb.jpg.flexi
    end
  end
end
