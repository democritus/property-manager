class Admin::ZonesController < Admin::AdminController

  before_filter :set_contextual_country
  
  # GET /zones
  # GET /zones.xml
  def index
    if @country
      @zones = @country.zones
    else
      @zones = Zone.all
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /zones/1
  # GET /zones/1.xml
  def show
    @zone = Zone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /zones/new
  # GET /zones/new.xml
  def new
    @zone = Zone.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /zones/1/edit
  def edit
    @zone = Zone.find(params[:id])
  end

  # POST /zones
  # POST /zones.xml
  def create
    if @country
      @zone = @country.zones.build(params[:zone])
    else
      @zone = Zone.new(params[:zone])
    end

    respond_to do |format|
      if @zone.save
        flash[:notice] = 'Zone was successfully created.'
        format.html { redirect_to(context_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /zones/1
  # PUT /zones/1.xml
  def update
    @zone = Zone.find(params[:id])

    respond_to do |format|
      if @zone.update_attributes(params[:zone])
        flash[:notice] = 'Zone was successfully updated.'
        format.html { redirect_to(context_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /zones/1
  # DELETE /zones/1.xml
  def destroy
    @zone = Zone.find(params[:id])
    @zone.destroy

    respond_to do |format|
      format.html {
        redirect_to(admin_country_zone_url(@zone.country, @zone)) }
    end
  end
  
  
  private

  # If nested, set parent instance variable
  def set_contextual_country
    if params[:context_type] == 'countries'
      @country = context_object( :include => :zones )
    end
  end

  # Allow nested access /countries/1/zones/1 or not nested access /zones/1
  def context_url
    if params[:context_type] == 'countries'
      admin_country_url(@country)
    else
      admin_zone_url(@zone)
    end
  end
end
