class Admin::PropertiesController < Admin::AdminController

  before_filter :require_user
  before_filter :set_contextual_agency
  
  # GET /properties
  # GET /properties.xml
  def index
    if @agency
      @properties = @agency.properties
    else
  # TODO: no need to include first-level associations here?
      @properties = Property.all
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /properties/1
  # GET /properties/1.xml
  def show
    @property = Property.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /properties/new
  # GET /properties/new.xml
  def new
    @property = Property.new
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /properties/1/edit
  def edit
    # TODO: no need to include first-level associations here?
    @property = Property.find(params[:id], :include => :categories)
  end

  # POST /properties
  # POST /properties.xml
  def create
    if @agency
      @property = @agency.properties.build(params[:property])
    else
      @property = Property.new(params[:property])
    end

    respond_to do |format|
      if @property.save
        flash[:notice] = 'Property was successfully created.'
        # Redirect to new listing form if no listings exist
        unless @property.listings.empty?
          format.html { redirect_to(context_url) }
        else 
          format.html { redirect_to(new_admin_property_listing_url(@property)) }
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /properties/1
  # PUT /properties/1.xml
  def update
    @property = Property.find(params[:id])

    respond_to do |format|
      if @property.update_attributes(params[:property])
        flash[:notice] = 'Property was successfully updated.'
        format.html { redirect_to(admin_property_url(@property)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.xml
  def destroy
    @property = Property.find(params[:id])
    @property.destroy

    respond_to do |format|
      format.html { redirect_to(
        admin_agency_property_url(@property.agency, @property)) }
    end
  end

  # AJAX target for constraining list of barrios by zone and/or province
  def barrio_select
    conditions = {}
    # If adding property nested under agency, constrain by agency's country id
    if @agency
      conditions.merge!( { :country_id => @agency.country_id } )
    end
    unless params[:market_id].blank?
      conditions.merge!( { :market_id => params[:market_id] } )
    else
      unless params[:zone_id].blank?
        conditions.merge!( { :zone_id => params[:zone_id] } )
      end
      unless params[:province_id].blank?
        conditions.merge!( { :province_id => params[:province_id] } )
      end
    end
    barrios = Barrio.find(:all,
      :include => nil,
      :conditions => conditions,
      :select => 'id, name',
      :order => :name
    ).map { |barrio| [barrio.name, barrio.id] }
    
    render :partial => 'barrio_select',
      :layout => false,
      :locals => { :barrios => barrios }
  end


  private

  # If nested, set parent instance variable
  def set_contextual_agency
    if params[:context_type] == 'agencies'
      # TODO: no need to include first-level associations here?
      @agency = context_object( :include => :properties )
    end
  end

  # Allow nested access /agencies/1/properties/1 or
  # not nested access /agencies/1
  def context_url
    if params[:context_type] == 'agencies'
      admin_agencies_url(@agency)
    else
      admin_property_url(@property)
    end
  end
end
