class Admin::AgencyRelationshipsController < Admin::AdminController
  
  # GET /agency_relationships
  # GET /agency_relationships.xml
  def index
    @agency_relationships = AgencyRelationship.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /agency_relationships/1
  # GET /agency_relationships/1.xml
  def show
    @agency_relationship = AgencyRelationship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /agency_relationships/new
  # GET /agency_relationships/new.xml
  def new
    @agency_relationship = AgencyRelationship.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /agency_relationships/1/edit
  def edit
    @agency_relationship = AgencyRelationship.find(params[:id])
  end

  # POST /agency_relationships
  # POST /agency_relationships.xml
  def create
    @agency_relationship = AgencyRelationship.new(params[:agency_relationship])

    respond_to do |format|
      if @agency_relationship.save
        flash[:notice] = 'AgencyRelationship was successfully created.'
        format.html { redirect_to(
          agency_relationship_url(@agency_relationship)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /agency_relationships/1
  # PUT /agency_relationships/1.xml
  def update
    @agency_relationship = AgencyRelationship.find(params[:id])

    respond_to do |format|
      if @agency_relationship.update_attributes(params[:agency_relationship])
        flash[:notice] = 'AgencyRelationship was successfully updated.'
        format.html { redirect_to(
          agency_relationship_url(@agency_relationship)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /agency_relationships/1
  # DELETE /agency_relationships/1.xml
  def destroy
    @agency_relationship = AgencyRelationship.find(params[:id])
    @agency_relationship.destroy

    respond_to do |format|
      format.html { redirect_to(agency_relationships_url) }
    end
  end
end
