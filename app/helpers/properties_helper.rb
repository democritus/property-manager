module PropertiesHelper
    
  def css_thumbnail(image, listing_link)
    # TODO: Render thumbnail from base image using RMagic (via Fleximage plugin?)
    unless image.blank?
      thumbnail_name = image.image_filename.split('.').join('_th.');
      return '<div class="thumbnail">' +
          '<div class="alpha-shadow">' +
            '<div class="shadow">' +
              link_to(
                image_tag(thumbnail_name, :class=> 'shadowed'),
                listing_link
              ) +
            '</div>' +
          '</div>' +
        '</div>'
    end
  end

  def bed_and_bath_formatted(bedroom_number = nil, bathroom_number = nil)
    unless bedroom_number.blank? && bathroom_number.blank?
      bed_and_bath = []
      unless bedroom_number.blank? || bedroom_number.zero?
        bed_and_bath << bedroom_number.to_s + ' bed'
      end
      unless bathroom_number.blank? || bathroom_number.zero?
        bed_and_bath << bathroom_number.to_s + ' bath'
      end
      unless bed_and_bath.empty?
        return (bed_and_bath.join(' / '))
      end
    end
  end

  def construction_formatted(construction_size)
    unless construction_size.blank? || construction_size.zero?
      return h('Construction: ' +
        number_with_precision(
          construction_size,
          :precision => 0,
          :seperator => '.',
          :delimiter => ','
        ) + 'm² ' + '(' +
        number_with_precision(
          m2_to_ft2(construction_size),
          :precision => 0,
          :seperator => '.',
          :delimiter => ','
        ) + ' ft²)')
    end
  end

  def land_formatted(land_size)
    unless land_size.blank? || land_size.zero?
      return h('Land: ' +
        number_with_precision(
          land_size,
          :precision => 0,
          :seperator => '.',
          :delimiter => ','
        ) + 'm² ' + '(' +
        number_with_precision(
          m2_to_ft2(land_size),
          :precision => 0,
          :seperator => '.',
          :delimiter => ','
        ) + ' ft²)')
    end
  end

  def garage_formatted(garage_spaces)
    unless garage_spaces.blank? || garage_spaces.zero?
      return h(garage_spaces.to_s + '-car garage')
    end
  end

  def parking_formatted(parking_spaces)
    unless parking_spaces.blank? || parking_spaces.zero?
      return h(parking_spaces.to_s + ' parking spaces')
    end
  end

  def stories_formatted(stories)
    unless stories.blank? || stories.zero?
      return h(stories.to_s + ' stories')
    end
  end

  def year_built_formatted(year_built)
    unless year_built.blank? || year_built.zero?
      return h('Constructed in ' + year_built.to_s)
    end
  end

  def main_feature_list(listing = nil)
    listing = @listing unless listing
    
    list = []
    
    bed_and_bath = bed_and_bath_formatted(listing.property.bedroom_number,
      listing.property.bathroom_number)
    unless bed_and_bath.blank?
      list << bed_and_bath
    end

    construction = construction_formatted(listing.property.construction_size)
    unless construction.blank?
      list << construction
    end

    land = land_formatted(listing.property.land_size)
    unless land.blank?
      list << land
    end

    garage = garage_formatted(listing.property.garage_spaces)
    unless garage.blank?
      list << garage
    end

    parking = parking_formatted(listing.property.parking_spaces)
    unless parking.blank?
      list << parking
    end

    stories = stories_formatted(listing.property.stories)
    unless stories.blank?
      list << stories
    end

    year_built = year_built_formatted(listing.property.year_built)
    unless year_built.blank?
      list << year_built
    end

    return list
  end
end
