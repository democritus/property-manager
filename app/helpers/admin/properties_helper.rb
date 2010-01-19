module Admin::PropertiesHelper
  
  # Call helper function that set up options and selections for select boxes
  def setup_property_fields
    set_property_form_list_data
    
    # Non-model fields: pre-select market or zone/province
    if params[:property]
      barrio_id = params[:property][:barrio_id]
    elsif @property.barrio_id
      barrio_id = @property.barrio_id
    end
    if barrio_id
      barrio = Barrio.find(:first,
        :include => nil,
        :conditions => ['barrios.id = ?', barrio_id]
      )
      # Pre-select zone and province on form reload
      if barrio
        unless barrio.market_id.blank?
          @lists[:barrios] = Barrio.find(:all,
            :include => nil,
            :conditions => [ 'barrios.market_id = :x',
              { :x => barrio.market_id } ]
          ).map { |barrio| [barrio.name, barrio.id] }
        else
          @lists[:barrios] = Barrio.find(:all,
            :include => nil,
            :conditions => [ 'barrios.zone_id = :x AND barrios.province_id = :y',
              { :x => barrio.zone_id, :y => barrio.province_id } ]
          ).map { |barrio| [barrio.name, barrio.id] }
        end
      end
    end
    # If adding new or no barrio selected, show prompt to select province and zone
    unless @lists[:barrios]
      @lists[:barrios] = [['Please choose Market or Zone/Province above', '']]
    end

    # Overwrite posted values with values derived from selected barrio
    if barrio
      if barrio.market_id
        params[:market_id] = barrio.market_id.to_i
        params[:zone_id] = ''
        params[:province_id] = ''
      else
        params[:market_id] = ''
        params[:zone_id] = barrio.zone_id.to_i if barrio.zone_id
        params[:province_id] = barrio.province_id.to_i if barrio.province_id
      end
    end
  end
  
  def set_property_form_list_data
    @lists = {}
    conditions = { :country_id => @active_agency.country_id }
    @lists[:agencies] = Agency.find(:all,
      :include => nil,
      :conditions => conditions,
      :select => 'id, name'
    ).map {
      |agency| [agency.name, agency.id] }
    @lists[:markets] = Market.find(:all,
      :include => nil,
      :conditions => conditions,
      :select => 'id, name'
    ).map { |market| [market.name, market.id] }
    @lists[:zones] = Zone.find(:all,
      :include => nil,
      :conditions => conditions,
      :select => 'id, name'
    ).map { |zone| [zone.name, zone.id] }
    @lists[:provinces] = Province.find(:all,
      :include => nil,
      :conditions => conditions,
      :select => 'id, name'
    ).map {
      |province| [province.name, province.id] }
    #@lists[:barrios] = Barrio.find(:all,
    #  :include => nil,
    #  :conditions => conditions,
    #  :select => 'id, name'
    #).map {
    #  |barrio| [barrio.name, barrio.id] }
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
  
  def primary_property_category(property = nil)
    property = @property unless property
    if property.categories[0]
      property.categories[0].name
    else
      'Not yet assigned'
    end
  end
  
  def primary_property_style(property = nil)
    property = @property unless property
    if property.styles[0]
      property.styles[0].name
    else
      'Not yet assigned'
    end
  end
end
