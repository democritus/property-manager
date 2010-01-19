class Admin::AgencyJurisdictionsController < Admin::AdminController

  before_filter :require_user
  
  # GET /agency_jurisdictions
  # GET /agency_jurisdictions.xml
  def index
    @agency_jurisdictions = AgencyJurisdiction.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /agency_jurisdictions/1
  # GET /agency_jurisdictions/1.xml
  def show
    @agency_jurisdiction = AgencyJurisdiction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /agency_jurisdictions/new
  # GET /agency_jurisdictions/new.xml
  def new
    @agency_jurisdiction = AgencyJurisdiction.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /agency_jurisdictions/1/edit
  def edit
    @agency_jurisdiction = AgencyJurisdiction.find(params[:id])
  end

  # POST /agency_jurisdictions
  # POST /agency_jurisdictions.xml
  def create
    @agency_jurisdiction = AgencyJurisdiction.new(params[:agency_jurisdiction])

    respond_to do |format|
      if @agency_jurisdiction.save
        flash[:notice] = 'AgencyJurisdiction was successfully created.'
        format.html { redirect_to(
          admin_agency_jurisdiction_url(@agency_jurisdiction)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /agency_jurisdictions/1
  # PUT /agency_jurisdictions/1.xml
  def update
    @agency_jurisdiction = AgencyJurisdiction.find(params[:id])

    respond_to do |format|
      if @agency_jurisdiction.update_attributes(params[:agency_jurisdiction])
        flash[:notice] = 'AgencyJurisdiction was successfully updated.'
        format.html { redirect_to(
          admin_agency_jurisdiction_url(@agency_jurisdiction)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /agency_jurisdictions/1
  # DELETE /agency_jurisdictions/1.xml
  def destroy
    @agency_jurisdiction = AgencyJurisdiction.find(params[:id])
    @agency_jurisdiction.destroy

    respond_to do |format|
      format.html { redirect_to(admin_agency_jurisdictions_url) }
    end
  end
end
