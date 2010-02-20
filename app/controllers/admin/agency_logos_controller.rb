class Admin::AgencyLogosController < Admin::AdminController

  before_filter :set_agency_logoable
  
  caches_page :show
  
  # GET /agency_logos
  # GET /agency_logos.xml
  def index
    @agency_logos = @agency_logoable.agency_logos

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /agency_logos/new
  # GET /agency_logos/new.xml
  def new
    @agency_logo = AgencyLogo.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /agency_logos/1/edit
  def edit
    @agency_logo = AgencyLogo.find(params[:id])
  end

  # POST /agency_logos
  # POST /agency_logos.xml
  def create
    @agency_logo = @agency_logoable.agency_logos.build( params[:agency_logo] )

    respond_to do |format|
      if @agency_logo.save
        flash[:notice] = 'AgencyLogo was successfully created.'
        format.html { redirect_to(
          polymorphic_url(:admin, [@agency_logoable, :agency_logos])) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /agency_logos/1
  # PUT /agency_logos/1.xml
  def update
    @agency_logo = AgencyLogo.find(params[:id])

    respond_to do |format|
      if @agency_logo.update_attributes(params[:agency_logo])
        flash[:notice] = 'AgencyLogo was successfully updated.'
        format.html { redirect_to(
          polymorphic_url(:admin, [@agency_logoable, :agency_logos])) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /agency_logos/1
  # DELETE /agency_logos/1.xml
  def destroy
    @agency_logo = AgencyLogo.find(params[:id])
    @agency_logo.destroy

    respond_to do |format|
      format.html { redirect_to(
        polymorphic_url(:admin, [@agency_logoable, :agency_logos])) }
    end
  end
  
  
  private

  # If nested, set parent instance variable
  def set_agency_logoable
    unless params[:context_type].nil?
      @agency_logoable = context_object( :include => :agency_logos )
    end
  end
  
end
