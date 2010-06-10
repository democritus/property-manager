# TODO: write script to grab these from Web and/or text file
# Grab all countries from online list
#require 'open-uri'
#
#Country.delete_all
#open("http://openconcept.ca/sites/openconcept.ca/files/country_code_drupal_0.txt") do |countries|
#  countries.read.each_line do |country|
#    iso2, name = country.chomp.split("|")
#    Country.create!(:name => name, :nationality => name, :iso2 => iso2)
#    puts name
#  end
#end
Country.delete_all
i = 0
[
  { :name => 'Costa Rica', :iso2 => 'CR', :nationality => 'Costarricense', :alphabetic_code => 'CRC' }
].each do |record|
  currency = Currency.find_by_alphabetic_code(record[:alphabetic_code],
    :select => [ :id ]
  )
  if currency
    record.merge!(:currency_id => currency.id) unless currency.id.blank?
  end
  record.merge!(:position => i + 1) unless record[:position]
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  Country.create!(key_value_hash)
  i += 1
end

Zone.delete_all
i = 0
[
  { :name => 'North Pacific', :iso2 => 'CR' },
  { :name => 'Central Pacific', :iso2 => 'CR' },
  { :name => 'South Pacific', :iso2 => 'CR' },
  { :name => 'Caribbean', :iso2 => 'CR' },
  { :name => 'Central Valley', :iso2 => 'CR' },
  { :name => 'Northern Plains', :iso2 => 'CR' }
].each do |record|
  country = Country.find_by_iso2(record[:iso2],
    :select => [ :id ]
  )
  next unless country
  record.merge!(:country_id => country.id)
  record.merge!(:position => i + 1) unless record[:position]
  record.delete(:iso2)
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  Zone.create!(key_value_hash)
  i += 1
end

Province.delete_all
i = 0
[
  { :name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Cartago', :iso2 => 'CR' },
  { :name => 'Guanacaste', :iso2 => 'CR' },
  { :name => 'Heredia', :iso2 => 'CR' },
  { :name => 'Limón', :iso2 => 'CR' },
  { :name => 'Puntarenas', :iso2 => 'CR' },
  { :name => 'San José', :iso2 => 'CR' }
].each do |record|
  country = Country.find_by_iso2(record[:iso2],
    :select => [ :id ]
  )
  next unless country
  record.merge!(:country_id => country.id)
  record.merge!(:position => i + 1) unless record[:position]
  record.delete(:iso2)
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  Province.create!(key_value_hash)
  i += 1
end

Canton.delete_all
i = 0
[
  { :name => 'Alajuela', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'San Ramón', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Grecia', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'San Mateo', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Atenas', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Naranjo', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Palmares', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Poás', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Orotina', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'San Carlos', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Alfaro Ruiz', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Valverde Vega', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Upala', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Los Chiles', :province_name => 'Alajuela', :iso2 => 'CR' },
  { :name => 'Guatuso', :province_name => 'Alajuela', :iso2 => 'CR' },
  
  { :name => 'Cartago', :province_name => 'Cartago', :iso2 => 'CR' },
  { :name => 'Paraíso', :province_name => 'Cartago', :iso2 => 'CR' },
  { :name => 'La Unión', :province_name => 'Cartago', :iso2 => 'CR' },
  { :name => 'Jiménez', :province_name => 'Cartago', :iso2 => 'CR' },
  { :name => 'Turrialba', :province_name => 'Cartago', :iso2 => 'CR' },
  { :name => 'Alvarado', :province_name => 'Cartago', :iso2 => 'CR' },
  { :name => 'Oreamno', :province_name => 'Cartago', :iso2 => 'CR' },
  { :name => 'El Guarco', :province_name => 'Cartago', :iso2 => 'CR' },
  
  { :name => 'Liberia', :province_name => 'Guanacaste', :iso2 => 'CR' },
  { :name => 'Nicoya', :province_name => 'Guanacaste', :iso2 => 'CR' },
  { :name => 'Santa Cruz', :province_name => 'Guanacaste', :iso2 => 'CR' },
  { :name => 'Bagaces', :province_name => 'Guanacaste', :iso2 => 'CR' },
  { :name => 'Carrillo', :province_name => 'Guanacaste', :iso2 => 'CR' },
  { :name => 'Cañas', :province_name => 'Guanacaste', :iso2 => 'CR' },
  { :name => 'Abangares', :province_name => 'Guanacaste', :iso2 => 'CR' },
  { :name => 'Tilarán', :province_name => 'Guanacaste', :iso2 => 'CR' },
  { :name => 'Nandayure', :province_name => 'Guanacaste', :iso2 => 'CR' },
  { :name => 'La Cruz', :province_name => 'Guanacaste', :iso2 => 'CR' },
  { :name => 'Hajancha', :province_name => 'Guanacaste', :iso2 => 'CR' },
  
  { :name => 'Heredia', :province_name => 'Heredia', :iso2 => 'CR' },
  { :name => 'Barva', :province_name => 'Heredia', :iso2 => 'CR' },
  { :name => 'Santo Domingo', :province_name => 'Heredia', :iso2 => 'CR' },
  { :name => 'Santa Bárbara', :province_name => 'Heredia', :iso2 => 'CR' },
  { :name => 'San Rafael', :province_name => 'Heredia', :iso2 => 'CR' },
  { :name => 'San Isidro', :province_name => 'Heredia', :iso2 => 'CR' },
  { :name => 'Belén', :province_name => 'Heredia', :iso2 => 'CR' },
  { :name => 'Flores', :province_name => 'Heredia', :iso2 => 'CR' },
  { :name => 'San Pablo', :province_name => 'Heredia', :iso2 => 'CR' },
  { :name => 'Sarapiquí', :province_name => 'Heredia', :iso2 => 'CR' },
  
  { :name => 'Limón', :province_name => 'Limón', :iso2 => 'CR' },
  { :name => 'Pococí', :province_name => 'Limón', :iso2 => 'CR' },
  { :name => 'Siquirres', :province_name => 'Limón', :iso2 => 'CR' },
  { :name => 'Talamanca', :province_name => 'Limón', :iso2 => 'CR' },
  { :name => 'Matina', :province_name => 'Limón', :iso2 => 'CR' },
  { :name => 'Guácimo', :province_name => 'Limón', :iso2 => 'CR' },
  
  { :name => 'Puntarenas', :province_name => 'Puntarenas', :iso2 => 'CR' },
  { :name => 'Esparza', :province_name => 'Puntarenas', :iso2 => 'CR' },
  { :name => 'Buenos Aires', :province_name => 'Puntarenas', :iso2 => 'CR' },
  { :name => 'Montes de Oro', :province_name => 'Puntarenas', :iso2 => 'CR' },
  { :name => 'Osa', :province_name => 'Puntarenas', :iso2 => 'CR' },
  { :name => 'Aguirre', :province_name => 'Puntarenas', :iso2 => 'CR' },
  { :name => 'Golfito', :province_name => 'Puntarenas', :iso2 => 'CR' },
  { :name => 'Coto Brus', :province_name => 'Puntarenas', :iso2 => 'CR' },
  { :name => 'Parrita', :province_name => 'Puntarenas', :iso2 => 'CR' },
  { :name => 'Corredores', :province_name => 'Puntarenas', :iso2 => 'CR' },
  { :name => 'Garabito', :province_name => 'Puntarenas', :iso2 => 'CR' },
  
  { :name => 'San José', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Escazú', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Desamparados', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Puriscal', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Tarrazú', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Aserrí', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Mora', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Goicoechea', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Santa Ana', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Alajuelita', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Vázquez de Coronado', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Acosta', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Tibás', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Moravia', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Montes de Oca', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Turrubares', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Dota', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Curridabat', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'Pérez Zeledón', :province_name => 'San José', :iso2 => 'CR' },
  { :name => 'León Cortés', :province_name => 'San José', :iso2 => 'CR' }
].each do |record|
  province = Province.find(:first,
    :joins => :country,
    :conditions => [
      'provinces.name = :province_name AND countries.iso2 = :iso2',
      { :province_name => record[:province_name], :iso2 => record[:iso2] }
    ],
    :select => 'provinces.id'
  )
  next unless province
  record.merge!(:position => i + 1) unless record[:position]
  record.merge!(:province_id => province.id)
  record.delete(:iso2)
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  Canton.create!(key_value_hash)
  i += 1
end

Barrio.delete_all
i = 0
[
  { :name => 'Aves de Paraiso', :zone_name => 'Central Valley', :province_name => 'Heredia', :market_name => 'Heredia', :canton_name => 'San Rafael' }
].each do |record|
  zone = Zone.find(:first,
    :joins => :country,
    :conditions => [
      'countries.iso2 = :iso2' +
      ' AND zones.name = :zone_name' +
      {
        :iso2 => record[:iso2],
        :zone_name => record[:zone_name],
      }
    ],
    :select => 'countries.id, zones.id'
  )
  next unless zone
  province = Province.find(:first,
    :conditions => [
      'provinces.country_id = :country_id' +
      ' AND provinces.name = :province_name' +
      {
        :country_id => zone.country_id,
        :province_name => record[:province_name],
      }
    ],
    :select => 'provinces.id'
  )
  next unless province
  market = Market.find(:first,
    :conditions => [
      'markets.country_id = :country_id' +
      ' AND markets.name = :market_name' +
      {
        :country_id => zone.country_id,
        :market_name => record[:market_name],
      }
    ],
    :select => 'markets.id'
  )
  canton = Canton.find(:first,
    :conditions => [
      'cantons.province_id = :province_id' +
      ' AND cantons.name = :canton_name' +
      {
        :province_id => province.id,
        :canton_name => record[:canton_name],
      }
    ],
    :select => 'provinces.id'
  )
  record.merge!(:position => i + 1) unless record[:position]
  record.merge!(:country_id => zone.country_id)
  record.merge!(:zone_id => zone.id)
  record.merge!(:province_id => province.id)
  record.merge!(:market_id => market.id) if market
  record.merge!(:canton_id => canton.id) if canton
  record.delete(:iso2)
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  Barrio.create!(key_value_hash)
  i += 1
end

Agency.delete_all
i = 0
[
  { :name => 'Default Agency', :short_name => 'Default', :master_agency => true, :iso2 => 'CR' }
].each do |record|
  country = Country.find_by_iso2(record[:iso2],
    :select => [ :id ]
  )
  next unless country
  record.merge!(:country_id => country.id)
  record.merge!(:position => i + 1) unless record[:position]
  record.delete(:iso2)
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  Agency.create!(key_value_hash)
  i += 1
end

Category.delete_all
i = 0
[
  { :name => 'Homes', :user_defined => false },
  { :name => 'Condos', :user_defined => false },
  { :name => 'Lots', :user_defined => false },
  { :name => 'Land for sale', :user_defined => false },
  { :name => 'Hotels', :user_defined => false },
  { :name => 'Apartments', :user_defined => false }
].each do |record|
  record.merge!(:position => i + 1) unless record[:position]
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  Category.create!(key_value_hash)
  i += 1
end

# TODO: write script to grab these from Web and/or text file
Currency.delete_all
i = 0
[
  { :name => 'Costa Rican Colón', :alphabetic_code => 'CRC', :symbol => '₡' },
  { :name => 'United States Dollar', :alphabetic_code => 'USD', :symbol => '$' }
].each do |record|
  record.merge!(:position => i + 1) unless record[:position]
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  Currency.create!(key_value_hash)
  i += 1
end

ListingType.delete_all
i = 0
[
  { :name => 'for sale' },
  { :name => 'for rent' }
].each do |record|
  record.merge!(:position => i + 1) unless record[:position]
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  ListingType.create!(key_value_hash)
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
  record.merge!(:position => i + 1) unless record[:position]
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  MarketSegment.create!(key_value_hash)
  i += 1
end

User.delete_all
i = 0
[
  { :login => 'admin', :email => 'admin@yourdomain.com', :first_name => 'Admin', :last_name => 'User', :password => 'password', :password_confirmation => 'password' }
].each do |record|
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  User.create!(key_value_hash)
  i += 1
end
