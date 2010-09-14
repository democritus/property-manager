class LegacyProperty < LegacyBase

  set_table_name 'real_estate_listing'
  set_primary_key 'PropertyID'
  
  # Join to self so that it is as if each property has an associated "listing"
  has_many :legacy_listings, :foreign_key => 'PropertyID'
  has_many :legacy_property_images, :foreign_key => 'PropertyID'
  
  has_many :legacy_categories, :through => :legacy_category_assignments
  has_many :legacy_styles, :through => :legacy_style_assignments
  has_many :legacy_features, :through => :legacy_feature_assignments
  
  has_many :legacy_category_assignments, :foreign_key => 'PropertyID'
  has_many :legacy_style_assignments, :foreign_key => 'PropertyID'
  has_many :legacy_feature_assignments, :foreign_key => 'PropertyID'
    
  def map
    {
      :name => self.PropertyName,
      :bedroom_number => self.BedroomNum,
      :bathroom_number => self.BathNum,
      :land_size => self.LandSize,
      :construction_size => self.ConstructionSize,
      :stories => self.Stories,
      :parking_spaces => self.ParkingSpaces,
      :year_built => self.YearBuilt,  
      :agency_id => forced_agency_id,
      :legacy_id => self.PropertyID,
      :barrio_id => new_barrio_id
    }
  end
  
  
  private
  
  def forced_agency_id
# TODO: load old data into a specific site
#    if RAILS_ENV == 'production'
#      order = '(domain = "qlogicinc.com" AND subdomain == "kwdemo") DESC'
#    else
#      order = '(domain = "barrioearth.com" AND subdomain IS NULL) DESC'
#    end
#    Agency.find( :first, :order => order ).id
    
    # Loading legacy data into the first agency found in database (just for
    # testing while there is only one agency)
    Agency.find( :first ).id
  end
  
  def new_canton_id
    canton = Canton.find( :first,
      :joins => { :province => :country },
      :conditions => [
        'cantons.name = :canton_name AND provinces.name = :province_name' +
          ' AND countries.iso2 = :country_iso2',
        { :canton_name => new_canton_name, :province_name => new_province_name,
          :country_iso2 => self.CountryID }
      ]
    )
    unless canton
      logger.debug "Not found: '#{new_canton_name}, #{new_province_name}" +
        ", #{self.CountryID}'"
    end
    return canton.id
  end
  
  def new_barrio_id
    return nil unless new_canton_id
    barrio = Barrio.find( :first,
      :joins => :canton,
      :conditions => [
        'barrios.name = :barrio_name AND cantons.id = :canton_id',
        { :barrio_name => new_barrio_name, 
        :canton_id => new_canton_id }
      ]
    )
    return barrio.id if barrio
    # Create new barrio if it doesn't exist yet
    new_barrio = Barrio.new(
      :name => new_barrio_name, :canton_id => new_canton_id
    )
    if id = new_barrio.save
      logger.debug "New barrio name: #{new_barrio_name}"
    else
      logger.debug "Barrio #{new_barrio_name} not created!"
    end
    return id || nil
  end
  
  def place_map
    place = {}
    if self.CountryID = 'CR'
      case self.BarrioID
      when 'parrita'
        place[:barrio_name] = 'Parrita'
        place[:canton_name] = 'Parrita'
        place[:province_name] = 'Puntarenas'
      when 'san_joaquin'
        place[:barrio_name] = 'San Joaquín'
        place[:canton_name] = 'Flores'
        place[:province_name] = 'Heredia'
      when 'playa_hermosa'
        place[:barrio_name] = 'Hermosa Beach'
        place[:canton_name] = 'Garabito'
        place[:province_name] = 'Puntarenas'
      when 'herradura'
        place[:barrio_name] = 'Herradura Beach'
        place[:canton_name] = 'Garabito'
        place[:province_name] = 'Puntarenas'
      when 'heredia'
        place[:barrio_name] = 'Downtown Heredia'
        place[:canton_name] = 'Heredia'
        place[:province_name] = 'Heredia'
      when 'alajuela'
        place[:barrio_name] = 'Alajuela'
        place[:canton_name] = 'Alajuela'
        place[:province_name] = 'Alajuela'
      when 'guacimo'
        place[:barrio_name] = 'Guácimo'
        place[:canton_name] = 'Guácimo'
        place[:province_name] = 'Limón'
      when 'barva'
        place[:barrio_name] = 'Barva'
        place[:canton_name] = 'Barva'
        place[:province_name] = 'Heredia'
      when 'san_rafael_hd'
        place[:barrio_name] = 'San Rafael'
        place[:canton_name] = 'San Rafael'
        place[:province_name] = 'Heredia'
      when 'santo_domingo'
        place[:barrio_name] = 'Quizarco'
        place[:canton_name] = 'Santo Domingo'
        place[:province_name] = 'Heredia'
      when 'san_isidro_hd'
        place[:barrio_name] = 'San Isidro'
        place[:canton_name] = 'San Isidro'
        place[:province_name] = 'Heredia'
      when 'santa_barbara'
        place[:barrio_name] = 'Santa Barbara'
        place[:canton_name] = 'Santa Barbara'
        place[:province_name] = 'Heredia'
      when 'escazu'
        place[:barrio_name] = 'Escazú'
        place[:canton_name] = 'Escazú'
        place[:province_name] = 'San José'
      when 'puerto_jimenez'
        place[:barrio_name] = 'Puerto Jiménez'
        place[:canton_name] = 'Golfito'
        place[:province_name] = 'Puntarenas'
      when 'jaco'
        place[:barrio_name] = 'Jacó Beach'
        place[:canton_name] = 'Garabito'
        place[:province_name] = 'Puntarenas'
      when 'esterillos_jaco'
        place[:barrio_name] = 'Esterillos Beach'
        place[:canton_name] = 'Garabito'
        place[:province_name] = 'Puntarenas'
      when 'santa_ana'
        place[:barrio_name] = 'Santa Ana'
        place[:canton_name] = 'Santa Ana'
        place[:province_name] = 'San José'
      when 'san_pablo'
        place[:barrio_name] = 'San Pablo'
        place[:canton_name] = 'San Pablo'
        place[:province_name] = 'Heredia'
      when 'santa_lucia'
        place[:barrio_name] = 'Santa Lucía'
        place[:canton_name] = 'Barva'
        place[:province_name] = 'Heredia'
      when 'monteverde'
        place[:barrio_name] = 'Monteverde'
        place[:canton_name] = 'Puntarenas'
        place[:province_name] = 'Puntarenas'
      when 'sabana'
        place[:barrio_name] = 'Sabana'
        place[:canton_name] = 'San José'
        place[:province_name] = 'San José'
      when 'atenas'
        place[:barrio_name] = 'Atenas'
        place[:canton_name] = 'Atenas'
        place[:province_name] = 'Alajuela'
      when 'cariari'
        place[:barrio_name] = 'Ciudad Cariari'
        place[:canton_name] = 'Belén'
        place[:province_name] = 'Heredia'
      when 'mercedes'
        place[:barrio_name] = 'Mercedes Norte'
        place[:canton_name] = 'Heredia'
        place[:province_name] = 'Heredia'
      when 'moravia'
        place[:barrio_name] = 'Moravia'
        place[:canton_name] = 'Moravia'
        place[:province_name] = 'San José'
      when 'punta_leona'
        place[:barrio_name] = 'Punta Leona'
        place[:canton_name] = 'Garabito'
        place[:province_name] = 'Puntarenas'
      when 'playas_del_coco'
        place[:barrio_name] = 'Playa del Coco'
        place[:canton_name] = 'Carrillo'
        place[:province_name] = 'Guanacaste'
      else
        place[:barrio_name] = nil
        place[:canton_name] = nil
        place[:province_name] = nil
      end
    end
    return place
  end
  
  def new_barrio_name
    place_map[:barrio_name]
  end
  
  def new_canton_name
    place_map[:canton_name]
  end
  
  def new_province_name
    place_map[:province_name]
  end
end
