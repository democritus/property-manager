# TODO: write script to grab these from Web and/or text file
Currency.delete_all
i = 0
[
  {
    :name => 'United States Dollar',
    :alphabetic_code => 'USD',
    :symbol => '$'
  },
  {
    :name => 'Euro',
    :alphabetic_code => 'EUR',
    :symbol => '€'
  },
  {
    :name => 'British Pound',
    :alphabetic_code => 'GBP',
    :symbol => '£'
  },
  {
    :name => 'Costa Rican Colón',
    :alphabetic_code => 'CRC',
    :symbol => '₡'
  }
].each do |record|
  record.merge!(:position => i + 1) unless record[:position]
  Currency.create!(record)
  i += 1
end

# Grab all countries from online list
require 'open-uri'
Country.delete_all
countries = []
url = 'http://openconcept.ca/sites/openconcept.ca/files/' +
  'country_code_drupal_0.txt'
open(url) do |data|
  data.read.each_line do |line|
    arr = line.chomp.split("|").map { |x| x.chomp }
    iso2, name = arr
    case iso2
    when 'CR'
      active = true
      nationality = 'Costa Rican'
      currency_code = 'CRC'
    when 'US'
      active = true
      nationality = 'American'
      currency_code = 'USD'
    else
      active = false
      nationality = name
      currency_code = nil
    end
    countries << {
      :name => name,
      :iso2 => iso2,
      :nationality => nationality,
      :currency_code => currency_code,
      :active => active
    }
  end
end
i = 0
countries.each do |record|
  if record[:currency_code]
    currency = Currency.find_by_alphabetic_code(record[:currency_code],
      :select => [ :id ]
    )
  end
  if currency
    record.merge!(:currency_id => currency.id) unless currency.id.blank?
  end
  record.merge!(:position => i + 1) unless record[:position]
  record.delete(:currency_code)
  Country.create!(record)
  i += 1
end

#Country.delete_all
#i = 0
#[
#  {
#    :name => 'Costa Rica',
#    :iso2 => 'CR', :nationality => 'Costarricense', :currency_code => 'CRC'
#  },
#  {
#    :name => 'United States',
#    :iso2 => 'US', :nationality => 'American', :currency_code => 'USD' }
#].each do |record|
#  currency = Currency.find_by_currency_code(record[:currency_code],
#    :select => [ :id ]
#  )
#  if currency
#    record.merge!(:currency_id => currency.id) unless currency.id.blank?
#  end
#  record.merge!(:position => i + 1) unless record[:position]
#  record.delete(:currency_code)
#  Country.create!(record)
#  i += 1
#end

Zone.delete_all
i = 0
[
  {
    :name => 'North Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Central Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'South Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Caribbean',
    :iso2 => 'CR'
  },
  {
    :name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Northern Plains',
    :iso2 => 'CR'
  }
].each do |record|
  country = Country.find_by_iso2(record[:iso2],
    :select => :id
  )
  next unless country
  record.merge!(:country_id => country.id)
  record.merge!(:position => i + 1) unless record[:position]
  record.delete(:iso2)
  Zone.create!(record)
  i += 1
end

Province.delete_all
i = 0
[
  {
    :name => 'Alajuela',
    :iso2 => 'CR'
  },
  {
    :name => 'Cartago',
    :iso2 => 'CR'
  },
  {
    :name => 'Ganacaste',
    :iso2 => 'CR'
  },
  {
    :name => 'Heredia',
    :iso2 => 'CR'
  },
  {
    :name => 'Limón',
    :iso2 => 'CR'
  },
  {
    :name => 'Puntarenas',
    :iso2 => 'CR'
  },
  {
    :name => 'San José',
    :iso2 => 'CR'
  }
].each do |record|
  country = Country.find_by_iso2(record[:iso2],
    :select => :id
  )
  next unless country
  record.merge!(:country_id => country.id)
  record.merge!(:position => i + 1) unless record[:position]
  record.delete(:iso2)
  Province.create!(record)
  i += 1
end

Canton.delete_all
i = 0
[
  {
    :name => 'Alajuela',
    :province_name => 'Alajuela',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'San Ramón',
    :province_name => 'Alajuela',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Grecia',
    :province_name => 'Alajuela',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'San Mateo',
    :province_name => 'Alajuela',
    :zone_name => 'Northern Plains',
    :iso2 => 'CR'
  },
  {
    :name => 'Atenas',
    :province_name => 'Alajuela',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Naranjo',
    :province_name => 'Alajuela',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Palmares',
    :province_name => 'Alajuela',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Poás',
    :province_name => 'Alajuela',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Orotina',
    :province_name => 'Alajuela',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'San Carlos',
    :province_name => 'Alajuela',
    :zone_name => 'Northern Plains',
    :iso2 => 'CR'
  },
  {
    :name => 'Alfaro Ruiz',
    :province_name => 'Alajuela',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Valverde Vega',
    :province_name => 'Alajuela',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Upala',
    :province_name => 'Alajuela',
    :zone_name => 'Northern Plains',
    :iso2 => 'CR'
  },
  {
    :name => 'Los Chiles',
    :province_name => 'Alajuela',
    :zone_name => 'Northern Plains',
    :iso2 => 'CR'
  },
  {
    :name => 'Guatuso',
    :province_name => 'Alajuela',
    :zone_name => 'Northern Plains',
    :iso2 => 'CR'
  },
  
  {
    :name => 'Cartago',
    :province_name => 'Cartago',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Paraíso',
    :province_name => 'Cartago',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'La Unión',
    :province_name => 'Cartago',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Jiménez',
    :province_name => 'Cartago',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Turrialba',
    :province_name => 'Cartago',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Alvarado',
    :province_name => 'Cartago',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Oreamno',
    :province_name => 'Cartago',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'El Guarco',
    :province_name => 'Cartago',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  
  {
    :name => 'Liberia',
    :province_name => 'Ganacaste',
    :zone_name => 'North Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Nicoya',
    :province_name => 'Ganacaste',
    :zone_name => 'North Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Santa Cruz',
    :province_name => 'Ganacaste',
    :zone_name => 'North Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Bagaces',
    :province_name => 'Ganacaste',
    :zone_name => 'North Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Carrillo',
    :province_name => 'Ganacaste',
    :zone_name => 'North Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Cañas',
    :province_name => 'Ganacaste',
    :zone_name => 'North Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Abangares',
    :province_name => 'Ganacaste',
    :zone_name => 'North Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Tilarán',
    :province_name => 'Ganacaste',
    :zone_name => 'North Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Nandayure',
    :province_name => 'Ganacaste',
    :zone_name => 'North Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'La Cruz',
    :province_name => 'Ganacaste',
    :zone_name => 'North Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Hajancha',
    :province_name => 'Ganacaste',
    :zone_name => 'North Pacific',
    :iso2 => 'CR'
  },
  
  {
    :name => 'Heredia',
    :province_name => 'Heredia',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Barva',
    :province_name => 'Heredia',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Santo Domingo',
    :province_name => 'Heredia',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Santa Bárbara',
    :province_name => 'Heredia',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'San Rafael',
    :province_name => 'Heredia',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'San Isidro',
    :province_name => 'Heredia',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Belén',
    :province_name => 'Heredia',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Flores',
    :province_name => 'Heredia',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'San Pablo',
    :province_name => 'Heredia',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Sarapiquí',
    :province_name => 'Heredia',
    :zone_name => 'Northern Plains',
    :iso2 => 'CR'
  },
  
  {
    :name => 'Limón',
    :province_name => 'Limón',
    :zone_name => 'Caribbean',
    :iso2 => 'CR'
  },
  {
    :name => 'Pococí',
    :province_name => 'Limón',
    :zone_name => 'Caribbean',
    :iso2 => 'CR'
  },
  {
    :name => 'Siquirres',
    :province_name => 'Limón',
    :zone_name => 'Caribbean',
    :iso2 => 'CR'
  },
  {
    :name => 'Talamanca',
    :province_name => 'Limón',
    :zone_name => 'Caribbean',
    :iso2 => 'CR'
  },
  {
    :name => 'Matina',
    :province_name => 'Limón',
    :zone_name => 'Caribbean',
    :iso2 => 'CR'
  },
  {
    :name => 'Guácimo',
    :province_name => 'Limón',
    :zone_name => 'Caribbean',
    :iso2 => 'CR'
  },
  
  {
    :name => 'Puntarenas',
    :province_name => 'Puntarenas',
    :zone_name => 'Central Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Esparza',
    :province_name => 'Puntarenas',
    :zone_name => 'Central Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Buenos Aires',
    :province_name => 'Puntarenas',
    :zone_name => 'South Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Montes de Oro',
    :province_name => 'Puntarenas',
    :zone_name => 'Central Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Osa',
    :province_name => 'Puntarenas',
    :zone_name => 'South Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Aguirre',
    :province_name => 'Puntarenas',
    :zone_name => 'Central Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Golfito',
    :province_name => 'Puntarenas',
    :zone_name => 'South Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Coto Brus',
    :province_name => 'Puntarenas',
    :zone_name => 'South Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Parrita',
    :province_name => 'Puntarenas',
    :zone_name => 'Central Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Corredores',
    :province_name => 'Puntarenas',
    :zone_name => 'South Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Garabito',
    :province_name => 'Puntarenas',
    :zone_name => 'Central Pacific',
    :iso2 => 'CR'
  },
  
  {
    :name => 'San José',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Escazú',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Desamparados',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Puriscal',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Tarrazú',
    :province_name => 'San José',
    :zone_name => 'Central Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Aserrí',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Mora',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Goicoechea',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Santa Ana',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Alajuelita',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Vázquez de Coronado',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Acosta',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Tibás',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Moravia',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Montes de Oca',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Turrubares',
    :province_name => 'San José',
    :zone_name => 'Central Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Dota',
    :province_name => 'San José',
    :zone_name => 'Central Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'Curridabat',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR'
  },
  {
    :name => 'Pérez Zeledón',
    :province_name => 'San José',
    :zone_name => 'Central Pacific',
    :iso2 => 'CR'
  },
  {
    :name => 'León Cortés',
    :province_name => 'San José',
    :zone_name => 'Central Valley',
    :iso2 => 'CR' }
].each do |record|
  province = Province.find(:first,
    :joins => :country,
    :conditions => [
      'provinces.name = :province_name AND countries.iso2 = :iso2',
      { :province_name => record[:province_name],
    :iso2 => record[:iso2] }
    ],
    :select => 'provinces.id'
  )
  next unless province
  zone = Zone.find(:first,
    :joins => :country,
    :conditions => [
      'zones.name = :zone_name AND countries.iso2 = :iso2',
      { :zone_name => record[:zone_name],
    :iso2 => record[:iso2] }
    ],
    :select => 'zones.id'
  )
  next unless zone
  record.merge!(:position => i + 1) unless record[:position]
  record.merge!(:province_id => province.id)
  record.merge!(:zone_id => zone.id)
  record.delete(:iso2)
  Canton.create!(record)
  i += 1
end

MarketSegment.delete_all
i = 0
[
  { :name => 'residential' },
  { :name => 'beach homes' },
  { :name => 'vacation homes' },
  { :name => 'commercial' },
  { :name => 'businesses' },
  { :name => 'land for sale' }
].each do |record|
  record.merge!( :position => i + 1 ) unless record[:position]
  if market_segment = MarketSegment.create!( record )
    market_segment_images = []
    image_dir = RAILS_ROOT + '/seed_images/market_segment_images'
    dir = Dir.new( image_dir )
    j = 0
    dir.each do |filename|
      market_segment_images << {
        :imageable_id => market_segment.id,
        :imageable_type => 'MarketSegment',
        :position => j,
        :image_file => File.new( image_dir + '/' + filename, 'r' )
      }
      j++
    end
    MarketSegmentImage.create!( market_segment_images )
  end
  i += 1
end

Agency.delete_all
i = 0
[
  {
    :name => 'Default Agency',
    :short_name => 'Default',
    :master_agency => true,
    :iso2 => 'CR',
    :market_segment_name => 'residential'
  }
].each do |record|
  country = Country.find_by_iso2( record[:iso2], :select => :id )
  next unless country
  market_segment = Country.find_by_name( record[:market_segment_name],
    :select => :id )
  record.merge!( :country_id => country.id )
  record.merge!( :market_segment_id => market_segment.id ) if market_segment
  record.merge!( :position => i + 1 ) unless record[:position]
  record.delete( :iso2 )
  Agency.create!( record )
  i += 1
end

ListingType.delete_all
i = 0
[
  { :name => 'for sale' },
  { :name => 'for rent' }
].each do |record|
  record.merge!(:position => i + 1) unless record[:position]
  ListingType.create!(record)
  i += 1
end

Category.delete_all
i = 0
[
  { :name => 'Condominiums', :user_defined => false, :type => :both },
  { :name => 'Commercial', :user_defined => false, :type => :both },
  { :name => 'Apartments', :user_defined => false, :type => :both },
  { :name => 'Beachfront', :user_defined => false, :type => :sale },
  { :name => 'Oceanview', :user_defined => false, :type => :sale },
  { :name => 'Fine Homes & Estates', :user_defined => false, :type => :both },
  
  { :name => 'Vacation Rentals', :user_defined => false, :type => :rent },
  
  { :name => 'Homes', :user_defined => false, :type => :sale },
  { :name => 'Residential Lots', :user_defined => false, :type => :sale },
  { :name => 'Land', :user_defined => false, :type => :sale },
  { :name => 'Business Opportunities', :user_defined => false, :type => :sale },
  { :name => 'Hotels', :user_defined => false, :type => :sale },
  { :name => 'Bed & Breakfasts', :user_defined => false, :type => :sale },
  { :name => 'Restaurants & Bars', :user_defined => false, :type => :sale },
  { :name => 'Pre-construction', :user_defined => false, :type => :sale },
  { :name => 'Farms & Ranches', :user_defined => false, :type => :sale },
  { :name => 'Residential Development', :user_defined => false,
    :type => :sale },
  { :name => 'Commercial Development', :user_defined => false, :type => :sale }
].each do |record|
  record.merge!(:position => i + 1) unless record[:position]
  types = []
  record.each_pair do |key, value|
    case :type
    when :sale, :both
      types << 'for sale'
    when :rent, :both
      types << 'for rent'
    end
    record.delete(:type)
  end
  if category = Category.create!(record)
    types.each do |type|
      listing_type = ListingType.find_by_name(type)
      if listing_type
        CategoryAssignment.create!(
          :category_assignable_type => 'ListingType',
          :category_assignable_id => listing_type.id,
          :category_id => category.id
        )
      end
    end
  end
  i += 1
end

Feature.delete_all
i = 0
[
  { :name => 'swimming pool', :user_defined => false, :type => :both },
  { :name => 'hot water', :user_defined => false, :type => :both },
  { :name => 'hardwood floors', :user_defined => false, :type => :both },
  { :name => 'central air', :user_defined => false, :type => :both },
  { :name => 'central heat', :user_defined => false, :type => :both },
  { :name => 'spa/hot tub', :user_defined => false, :type => :both },
  { :name => 'carport', :user_defined => false, :type => :both },
  { :name => 'RV/boat parking', :user_defined => false, :type => :both },
  { :name => 'tennis court', :user_defined => false, :type => :both },
  { :name => 'disability features', :user_defined => false, :type => :both },
  { :name => 'den/office', :user_defined => false, :type => :both },
  { :name => 'energy efficient home', :user_defined => false, :type => :both },
  { :name => 'fireplace', :user_defined => false, :type => :both },
  { :name => 'burglar alarm', :user_defined => false, :type => :both },
  { :name => 'laundry room', :user_defined => false, :type => :both },
  { :name => 'insulated glass', :user_defined => false, :type => :both },
  { :name => 'front garden', :user_defined => false, :type => :both },
  { :name => 'back garden', :user_defined => false, :type => :both },
  { :name => 'front yard', :user_defined => false, :type => :both },
  { :name => 'backyard', :user_defined => false, :type => :both },
  { :name => 'basement', :user_defined => false, :type => :both },
  { :name => 'close to or on a paved road', :user_defined => false,
    :type => :both },
  { :name => 'privacy', :user_defined => false, :type => :both },
  { :name => 'natural area', :user_defined => false, :type => :both },
  { :name => 'close to surf break', :user_defined => false, :type => :both },
  { :name => 'close to school', :user_defined => false, :type => :both },
  { :name => 'close to hospital', :user_defined => false, :type => :both },
  { :name => 'close to services', :user_defined => false, :type => :both },
  { :name => 'close to airport', :user_defined => false, :type => :both },
  { :name => 'gated community', :user_defined => false, :type => :both },
  { :name => 'non-gated community', :user_defined => false, :type => :both },
  { :name => '24-hour security', :user_defined => false, :type => :both },
  { :name => 'air conditioning', :user_defined => false, :type => :both },
  { :name => 'ocean view', :user_defined => false, :type => :both },
  { :name => 'mountain view', :user_defined => false, :type => :both },
  
  { :name => 'washer/dryer', :user_defined => false, :type => :rent }
  
].each do |record|
  record.merge!(:position => i + 1) unless record[:position]
  types = []
  record.each_pair do |key, value|
    case :type
    when :sale, :both
      types << 'for sale'
    when :rent, :both
      types << 'for rent'
    end
    record.delete(:type)
  end
  if feature = Feature.create!(record)
    types.each do |type|
      listing_type = ListingType.find_by_name(type)
      if listing_type
        FeatureAssignment.create!(
          :feature_assignable_type => 'ListingType',
          :feature_assignable_id => listing_type.id,
          :feature_id => feature.id
        )
      end
    end
  end
  i += 1
end

Style.delete_all
i = 0
[
  { :name => 'A-Frame' },
  { :name => 'Bungalow' },
  { :name => 'Chalet' },
  { :name => 'Colonial' },
  { :name => 'Cottage' },
  { :name => 'Duplex' },
  { :name => 'Farmhouse' },
  { :name => 'Georgian' },
  { :name => 'Log Cabin' },
  { :name => 'Mobile' },
  { :name => 'Modern' },
  { :name => 'Queen Anne' },
  { :name => 'Quinta' },
  { :name => 'Ranch' },
  { :name => 'Split-level' },
  { :name => 'Studio' },
  { :name => 'Townhouse' },
  { :name => 'Victorian' }
].each do |record|
  record.merge!(:position => i + 1) unless record[:position]
  types = []
  record.each_pair do |key, value|
    case :type
    when :sale, :both
      types << 'for sale'
    when :rent, :both
      types << 'for rent'
    end
    record.delete(:type)
  end
  if style = Style.create!(record)
    types.each do |type|
      listing_type = ListingType.find_by_name(type)
      if listing_type
        StyleAssignment.create!(
          :style_assignable_type => 'ListingType',
          :style_assignable_id => listing_type.id,
          :style_id => style.id
        )
      end
    end
  end
  i += 1
end

User.delete_all
i = 0
[
  {
    :login => 'admin',
    :email => 'admin@yourdomain.com',
    :first_name => 'Admin',
    :last_name => 'User',
    :password => 'password',
    :password_confirmation => 'password'
  }
].each do |record|
  User.create!(record)
  i += 1
end
