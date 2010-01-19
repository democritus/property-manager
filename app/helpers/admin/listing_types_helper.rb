module Admin::ListingTypesHelper
  
  # Call helper function that set up options and selections for select boxes
  def set_listing_type_form_list_data
    @lists = {}
    @lists[:categories] = Category.find(:all,
      :include => nil,
      :select => 'id, name'
    ).map {
      |category| [category.name, category.id]
    }
    @lists[:features] = Feature.find(:all,
      :include => nil,
      :select => 'id, name'
    ).map {
      |feature| [feature.name, feature.id]
    }
    @lists[:styles] = Style.find(:all,
      :include => nil,
      :select => 'id, name'
    ).map {
      |style| [style.name, style.id]
    }
  end
end
