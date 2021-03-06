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
      alphabetic_code = 'CRC'
    when 'US'
      active = true
      nationality = 'American'
      alphabetic_code = 'USD'
    else
      active = false
      nationality = name
      alphabetic_code = nil
    end
    countries << {
      :name => name,
      :iso2 => iso2,
      :nationality => nationality,
      :alphabetic_code => alphabetic_code,
      :active => active
    }
  end
end
i = 0
countries.each do |record|
  if record[:alphabetic_code]
    currency = Currency.find_by_alphabetic_code(record[:alphabetic_code],
      :select => [ :id ]
    )
  end
  record.delete(:alphabetic_code)
  if currency
    record.merge!(:currency_id => currency.id) unless currency.id.blank?
  end
  Country.create!(record)
  i += 1
end

#Country.delete_all
#i = 0
#[
#  {
#    :name => 'Costa Rica',
#    :iso2 => 'CR', :nationality => 'Costarricense', :alphabetic_code => 'CRC'
#  },
#  {
#    :name => 'United States',
#    :iso2 => 'US', :nationality => 'American', :alphabetic_code => 'USD' }
#].each do |record|
#  currency = Currency.find_by_alphabetic_code(record[:alphabetic_code],
#    :select => [ :id ]
#  )
#  if currency
#    record.merge!(:currency_id => currency.id) unless currency.id.blank?
#  end
#  record.delete(:alphabetic_code)
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
  if market_segment = MarketSegment.create!( record )
    market_segment_images = []
    image_dir = RAILS_ROOT + '/seed_images/market_segment_images/' +
      record[:name].gsub(/\s/, '_')
    if File.directory?( image_dir )
      dir = Dir.new( image_dir )
      dir.each do |filename|
        unless filename == '.' || filename == '..'
          market_segment_images << {
            :imageable_id => market_segment.id,
            :imageable_type => 'MarketSegment',
            :image_file => File.new( image_dir + '/' + filename, 'r' )
          }
        end
      end
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
  ListingType.create!(record)
  i += 1
end

# TODO: make sure records are associated with listing types correctly
Category.delete_all
i = 0
[
  { :name => 'Condominiums', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => false },
  { :name => 'Commercial', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Apartments', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => true },
  { :name => 'Beachfront', :user_defined => false, :type => :sale,
    :sale_highlighted => true, :rent_highlighted => false },
  { :name => 'Oceanview', :user_defined => false, :type => :sale,
    :sale_highlighted => true, :rent_highlighted => false },
  { :name => 'Fine Homes & Estates', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  
  { :name => 'Vacation Rentals', :user_defined => false, :type => :rent,
    :sale_highlighted => false, :rent_highlighted => true },
  
  { :name => 'Homes', :user_defined => false, :type => :sale,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'Residential Lots', :user_defined => false, :type => :sale,
    :sale_highlighted => true, :rent_highlighted => false },
  { :name => 'Land', :user_defined => false, :type => :sale,
    :sale_highlighted => true, :rent_highlighted => false },
  { :name => 'Business Opportunities', :user_defined => false, :type => :sale,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Hotels', :user_defined => false, :type => :sale,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Bed & Breakfasts', :user_defined => false, :type => :sale,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Restaurants & Bars', :user_defined => false, :type => :sale,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Pre-construction', :user_defined => false, :type => :sale,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Farms & Ranches', :user_defined => false, :type => :sale,
    :sale_highlighted => true, :rent_highlighted => false },
  { :name => 'Residential Development', :user_defined => false,
    :type => :sale, :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Commercial Development', :user_defined => false, :type => :sale,
    :sale_highlighted => false, :rent_highlighted => false }
].each do |record|
  types = []
  case record[:type]
  when :sale, :both
    types << 'for sale'
  when :rent, :both
    types << 'for rent'
  end
  record.delete(:type)
  record.delete(:rent_highlighted)
  if category = Category.create!(record)
    types.each do |type|
      listing_type = ListingType.find_by_name(type)
      if listing_type
        attributes = {
          :category_assignable_type => 'ListingType',
          :category_assignable_id => listing_type.id,
          :category_id => category.id
        }
        case listing_type
        when :sale
          if record[:sale_highlighted]
            attributes.merge!( :highlighted => true )
            record.delete(:sale_highlighted)
          end
        when :rent
          if record[:rent_highlighted]
            attributes.merge!( :highlighted => true )
            record.delete(:rent_highlighted)
          end
        end
        CategoryAssignment.create!( attributes )
      end
    end
  end
  i += 1
end

# TODO: make sure records are associated with listing types correctly
Feature.delete_all
i = 0
[
  { :name => 'swimming pool', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => false },
  { :name => 'hot water', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'hardwood floors', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => false },
  { :name => 'central air', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'central heat', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'spa/hot tub', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'carport', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'RV/boat parking', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'tennis court', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'disability features', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'den/office', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'energy efficient home', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'fireplace', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'burglar alarm', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'laundry room', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'insulated glass', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'front garden', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'back garden', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'front yard', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'backyard', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'basement', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'close to or on a paved road', :user_defined => false,
    :type => :both, :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'privacy', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'natural area', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'close to surf break', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'close to school', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'close to hospital', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'close to services', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'close to airport', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'gated community', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'non-gated community', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => '24-hour security', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'air conditioning', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'ocean view', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => false },
  { :name => 'mountain view', :user_defined => false, :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'washer/dryer', :user_defined => false, :type => :both,
    :sale_highlighted => true, :rent_highlighted => true }
  
].each do |record|
  types = []
  case record[:type]
  when :sale, :both
    types << 'for sale'
  when :rent, :both
    types << 'for rent'
  end
  record.delete(:type)
  if feature = Feature.create!(record)
    types.each do |type|
      listing_type = ListingType.find_by_name(type)
      if listing_type
        attributes = {
          :feature_assignable_type => 'ListingType',
          :feature_assignable_id => listing_type.id,
          :feature_id => feature.id
        }
        case listing_type
        when :sale
          if record[:sale_highlighted]
            attributes.merge!( :highlighted => true )
            record.delete(:sale_highlighted)
          end
        when :rent
          if record[:rent_highlighted]
            attributes.merge!( :highlighted => true )
            record.delete(:rent_highlighted)
          end
        end
        FeatureAssignment.create!( attributes )
      end
    end
  end
  i += 1
end

# TODO: make sure records are associated with listing types correctly
Style.delete_all
i = 0
[
  { :name => 'A-Frame', :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Bungalow', :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'Chalet', :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Colonial', :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'Cottage', :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'Duplex', :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'Farmhouse', :type => :both,
    :sale_highlighted => true, :rent_highlighted => false },
  { :name => 'Georgian', :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Log Cabin', :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Mobile', :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Modern', :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'Queen Anne', :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Quinta', :type => :both,
    :sale_highlighted => true, :rent_highlighted => false },
  { :name => 'Ranch', :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'Split-level', :type => :both,
    :sale_highlighted => false, :rent_highlighted => false },
  { :name => 'Studio', :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'Townhouse', :type => :both,
    :sale_highlighted => true, :rent_highlighted => true },
  { :name => 'Victorian', :type => :both,
    :sale_highlighted => true, :rent_highlighted => true }
].each do |record|
  types = []
  case record[:type]
  when :sale, :both
    types << 'for sale'
  when :rent, :both
    types << 'for rent'
  end
  record.delete(:type)
  if style = Style.create!(record)
    types.each do |type|
      listing_type = ListingType.find_by_name(type)
      if listing_type
        attributes = {
          :style_assignable_type => 'ListingType',
          :style_assignable_id => listing_type.id,
          :style_id => style.id
        }
        case listing_type
        when :sale
          if record[:sale_highlighted]
            attributes.merge!( :highlighted => true )
            record.delete(:sale_highlighted)
          end
        when :rent
          if record[:rent_highlighted]
            attributes.merge!( :highlighted => true )
            record.delete(:rent_highlighted)
          end
        end
        StyleAssignment.create!( attributes )
      end
    end
  end
  i += 1
end

User.delete_all
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
end
