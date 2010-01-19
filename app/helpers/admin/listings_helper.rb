module Admin::ListingsHelper

  include Admin::PropertiesHelper
    
  # Call helper function that set up options and selections for select boxes
  def setup_listing_select_fields
    set_listing_form_list_data
  end

  def set_listing_form_list_data
    @lists = {}
    @lists[:categories] = Category.find(:all,
      :include => nil,
      :select => 'id, name'
    ).map {
      |category| [category.name, category.id] }
    @lists[:currencies] = Currency.find(:all,
      :include => nil,
      :select => 'id, code, symbol'
    ).map {
      |currency| [currency.code + ' ' + currency.symbol, currency.id] }
    #@lists[:styles] = Style.find(:all,
    #  :include => nil,
    #  :select => 'id, name'
    #).map {
    #  |style| [style.name, style.id] }
      
    # Listing type object - used to get lists for listing types as well as
    # associated lists dependent on listing type
    @listing_types = ListingType.find(:all,
      :include => [ :categories, :features, :styles ]
    )
    @lists[:listing_types] = @listing_types.map {
      |listing_type| [listing_type.name, listing_type.id] }
      
    # Lists pre-screened according to either "rent" or "sale" listing type
    @lists[:categories] = []
    @lists[:styles] = []
    @lists[:features] = []
    unless @lists[:listing_types].empty?
      i = 0
      @lists[:listing_types].each_with_index do |listing_type, i|
        break if listing_type[1] == @listing.listing_type_id
      end
      @lists[:categories] = @listing_types[i].categories.map {
        |category| [category.name, category.id] }
      @lists[:styles] = @listing_types[i].styles.map {
        |style| [style.name, style.id] }
      @lists[:features] = @listing_types[i].features.map {
        |feature| [feature.name, feature.id] }
    end
    #@lists[:sale_categories] = @listing_types[0].categories.map {
    #  |category| [category.name, category.id] }
    #@lists[:rent_categories] = @listing_types[1].categories.map {
    #  |category| [category.name, category.id] }
    #@lists[:sale_styles] = @listing_types[0].styles.map {
    #  |style| [style.name, style.id] }
    #@lists[:rent_styles] = @listing_types[1].styles.map {
    #  |style| [style.name, style.id] }
      
    # id arrays used by JavaScript to help determine if an option or checkbox
    # should be visible
    #@sale_category_ids = @listing_types[0].categories.map {
    #  |category| category.id }
    #@rent_category_ids = @listing_types[1].categories.map {
    #  |category| category.id } 
    #@sale_feature_ids = @listing_types[0].features.map {
    #  |feature| feature.id }
    #@rent_feature_ids = @listing_types[1].features.map {
    #  |feature| feature.id } 
    #@sale_style_ids = @listing_types[0].styles.map {
    #  |style| style.id }
    #@rent_style_ids = @listing_types[1].styles.map {
    #  |style| style.id } 
    #@lists[:features] = Feature.find(:all,
    #  :include => nil,
    #  :select => 'id, name'
    #).map {
    #  |feature| [feature.name, feature.id]
    #}
  end
  
  def form_name(listing = nil)
    listing = @listing unless listing
    if listing.id
      return 'edit_listing_' + listing.id.to_s
    end
    return 'new_listing'
  end
  
  def primary_listing_category(listing = nil)
    listing = @listing unless listing
    if listing.categories[0]
      listing.categories[0].name
    else
      'Not yet assigned'
    end
  end
  
  def primary_listing_style(listing = nil)
    listing = @listing unless listing
    if listing.styles[0]
      listing.styles[0].name
    else
      'Not yet assigned'
    end
  end
end
