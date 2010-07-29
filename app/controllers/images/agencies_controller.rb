class Images::AgenciesController < Images::ImagesController
  
  caches_fleximage :default_logo
  
  # GET /agencies/1/default_logo
  def default_logo
    infer_agency
    
    respond_to do |format|
      format.png  # default.png.flexi
    end
  end
  
  
  private
  
  def infer_agency
    if params[:id]
      @agency = Agency.find(params[:id])
    else
      @agency = active_agency
    end
  end
end
