class Admin::ListingTypesController < Admin::AdminController

  before_filter :require_user
  
  # GET /listing_types
  # GET /listing_types.xml
  def index
    @listing_types = ListingType.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /listing_types/1
  # GET /listing_types/1.xml
  def show
    @listing_type = ListingType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /listing_types/new
  # GET /listing_types/new.xml
  def new
    @listing_type = ListingType.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /listing_types/1/edit
  def edit
    @listing_type = ListingType.find(params[:id])
  end

  # POST /listing_types
  # POST /listing_types.xml
  def create
    @listing_type = ListingType.new(params[:listing_type])

    respond_to do |format|
      if @listing_type.save
        flash[:notice] = 'ListingType was successfully created.'
        format.html { redirect_to(admin_listing_type_url(@listing_type)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /listing_types/1
  # PUT /listing_types/1.xml
  def update
    @listing_type = ListingType.find(params[:id])

    respond_to do |format|
      if @listing_type.update_attributes(params[:listing_type])
        flash[:notice] = 'ListingType was successfully updated.'
        format.html { redirect_to(admin_listing_type_url(@listing_type)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /listing_types/1
  # DELETE /listing_types/1.xml
  def destroy
    @listing_type = ListingType.find(params[:id])
    @listing_type.destroy

    respond_to do |format|
      format.html { redirect_to(listing_types_url) }
    end
  end
end
