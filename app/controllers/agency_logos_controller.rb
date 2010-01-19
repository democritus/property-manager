class AgencyLogosController < ApplicationController
  
  # TODO: need to cache separate default logo for each agency instead of just
  # one for all agencies
  caches_page :show, :thumb
  
  # GET /agency_logos/1
  # GET /agency_logos/1.xml
  # GET /agency_logos/1.png
  def show
    @agency_logo = AgencyLogo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @agency_logo }
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
