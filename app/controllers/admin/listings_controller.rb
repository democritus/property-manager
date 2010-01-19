class Admin::ListingsController < Admin::AdminController

  # Module for translating search parameters into readable string and back again
  include ReadableSearch
  
  before_filter :require_user, :except => [ :index, :show ]
  before_filter :set_contextual_property
  
  #caches_page :large_glider
  
  # GET /listings
  # GET /listings.xml
  def index   
    @listings = @property.listings.paginate(
      :page => params[:page]
    )    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /listings/1
  # GET /listings/1.xml
  def show
    @listing = Listing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end

  end

  # GET /listings/new
  # GET /listings/new.xml
  def new
    @listing = Listing.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /listings/1/edit
  def edit
    @listing = Listing.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /listings
  # POST /listings.xml
  def create
    @listing = @property.listings.build(params[:listing])

    respond_to do |format|
      if @listing.save
        flash[:notice] = 'Listing was successfully created.'
        format.html { redirect_to(
          admin_agency_property_path(@property.agency, @property)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /listings/1
  # PUT /listings/1.xml
  def update
    @listing = Listing.find(params[:id])

    respond_to do |format|
      if @listing.update_attributes(params[:listing])
        flash[:notice] = 'Listing was successfully updated.'
        format.html {
          redirect_to(admin_property_listing_url(@listing.property, @listing)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.xml
  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy

    respond_to do |format|
      format.html { redirect_to(
        admin_agency_property_path(@property.agency, @property)) }
    end
  end

  # AJAX target for updating fields based on checked listing type
  def listing_type_pivot
    ajax = {}
    # Clean incoming parameters
    listing_id = params[:listing_id].to_i
    listing_type_id = params[:listing_type_id].to_i
    primary_category_id = params[:primary_category_id].to_i
    primary_style_id = params[:primary_style_id].to_i
    
    category_ids = params[:category_ids].split(',').map { |x| x.to_i }
    style_ids = params[:style_ids].split(',').map { |x| x.to_i }
    feature_ids = params[:feature_ids].split(',').map { |x| x.to_i }
    
    # Fetch currently-checked listing type and associated data
    listing_type = ListingType.find(listing_type_id,
# REMOVED: experimenting with joins
#      :joins => "LEFT OUTER JOIN (`category_assignments`" +
#          " INNER JOIN `categories`" +
#            " ON `categories`.`id` = `category_assignments`.`category_id`)" +
#          " ON `category_assignments`.`category_assignable_type` = 'ListingType'" +
#            " AND `category_assignments`.`category_assignable_id` = `listing_types`.`id`" +
#        " LEFT OUTER JOIN (`style_assignments`" +
#          " INNER JOIN `styles`" +
#            " ON `styles`.`id` = `style_assignments`.`style_id`)" +
#          " ON `style_assignments`.`style_assignable_type` = 'ListingType'" +
#            " AND `style_assignments`.`style_assignable_id` = `listing_types`.`id`" +
#        " LEFT OUTER JOIN (`feature_assignments`" +
#          " INNER JOIN `features`" +
#            " ON `features`.`id` = `feature_assignments`.`feature_id`)" +
#          " ON `feature_assignments`.`feature_assignable_type` = 'ListingType'" +
#            " AND `feature_assignments`.`feature_assignable_id` = `listing_types`.`id`",
      :include => [ :categories, :features, :styles ]
    )
    ajax[:categories] = listing_type.categories.map {
      |category| [category.name, category.id] }
    ajax[:styles] = listing_type.styles.map {
      |style| [style.name, style.id] }
    ajax[:features] = listing_type.features.map {
      |feature| [feature.name, feature.id] }
      
    # Default values to pass to javascript (prevent nils)
    ajax[:primary_category_id] = primary_category_id || ''
    ajax[:primary_style_id] = primary_style_id || ''
    ajax[:category_ids] = []
    ajax[:style_ids] = []
    ajax[:feature_ids] = []
    unless listing_id.zero?
      listing = Listing.find(listing_id,
        :include => [ :primary_category, :primary_style, :categories,
          :styles, :features ]
      )
      # Use user-selected values if they exist, otherwise, use values looked up
      # from database
      if listing
        if primary_category_id.zero? && listing.primary_category
          ajax[:primary_category_id] = listing.primary_category.id
        end
        if primary_style_id.zero? && listing.primary_style
          ajax[:primary_style_id] = listing.primary_style.id
        end
        
#        # REMOVED - better to get from database
#        # Use selected values if any are selected (tries to respect user's
#        # changes on form)
#        ajax[:category_ids] = category_ids
#        ajax[:style_ids] = style_ids
#        ajax[:feature_ids] = feature_ids
        
        # Get selected values from database (discards user's changes on form)
        if listing.categories
          ajax[:category_ids] = listing.categories.map {
            |category| category.id }
        end
        if listing.styles
          ajax[:style_ids] = listing.styles.map { |style| style.id }
        end
        if listing.features
          ajax[:feature_ids] = listing.features.map { |feature| feature.id }
        end
      end
    end
    render :partial => 'listing_type_pivot',
      :layout => false,
      :locals => { :ajax => ajax }
  end


  private

  # If nested, set parent instance variable
  def set_contextual_property
    if params[:context_type] == 'properties'
      @property = context_object( :include => :listings )
    end
  end
end
