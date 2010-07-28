class Admin::ListingsController < Admin::AdminController

  # Module for translating search parameters into readable string and back again
  include ReadableSearch
  
  before_filter :set_contextual_property
  
  def index   
    @listings = @property.listings.paginate(
      :page => params[:page]
    )
  end
  
  def show
    @listing = Listing.find( params[:id] )
  end
  def new
    @listing = Listing.new
  end

  def edit
    @listing = Listing.find( params[:id] )
  end

  def create
    @listing = @property.listings.build(params[:listing])
    if @listing.save
      flash[:notice] = 'Listing was successfully created.'
      redirect_to( admin_agency_property_path( @property.agency, @property ) )
    else
      render :new
    end
  end

  def update
    @listing = Listing.find(params[:id])    
    if @listing.update_attributes(params[:listing])
      flash[:notice] = 'Listing was successfully updated.'
      redirect_to( admin_property_listing_url( @listing.property, @listing ) )
    else
      render :edit
    end
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    redirect_to( admin_agency_property_path( @property.agency, @property ) )
  end

  # AJAX target for updating fields based on checked listing type
  def listing_type_pivot
    ajax = {}
    # Clean incoming parameters
    listing_id = params[:listing_id].to_i
    listing_type_id = params[:listing_type_id].to_i
    primary_category_id = params[:primary_category_id].to_i
    primary_style_id = params[:primary_style_id].to_i
    
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
    
    # If new record, get values from property that should be inherited
    if listing_id.zero?
      property = Property.find(params[:property_id])
      if primary_style_id.zero?
        ajax[:primary_style_id] = property.primary_style_id
      end
      ajax[:category_ids] = property.category_ids
      ajax[:style_ids] = property.style_ids
      ajax[:feature_ids] = property.feature_ids
    else
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
