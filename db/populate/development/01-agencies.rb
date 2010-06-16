# Agency
##
i = 0
[
  {
    :name => 'BarrioEarth Real Estate',
    :short_name => 'BarrioEarth',
    :domain => 'barrioearth.com',
    :subdomain => 'rails',
    :master_agency => true,
    :email => 'realestate@barrioearth.com',
    :skype => 'barrioearth',
    :iso2 => 'CR'
  },
  {
    :name => 'BarrioEarth Heredia',
    :short_name => 'Heredia',
    :domain => 'barrioearth.com',
    :subdomain => 'heredia',
    :email => 'heredia@barrioearth.com',
    :skype => 'heredia.barrioearth',
    :iso2 => 'CR'
  }
  {
    :name => 'BarrioEarth Jacó',
    :short_name => 'Jacó Beach',
    :domain => 'barrioearth.com',
    :subdomain => 'jaco',
    :email => 'jaco@barrioearth.com',
    :skype => 'jaco.barrioearth',
    :iso2 => 'CR'
  }
].each do |record|
  country = Country.find_by_iso2(record[:iso2],
    :select => [ :id ]
  )
  record.merge!(:country_id => country.id) if country
  record.merge!(:position => i + 1) unless record[:position]
  record.delete(:iso2)
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  Agency.create!(key_value_hash)
  i += 1
end

# SiteText
##
i = 0
[
  # BarrioEarth Real Estate
  {
    :name => 'web_contact_note',
    :value => 'We respond to all inquiries within 24 hours',
    :agency_name => 'BarrioEarth Real Estate'
  },
  {
    :name => 'office_phone',
    :value => '+001 506 2244 8776',
    :agency_name => 'BarrioEarth Real Estate'
  },
  {
    :name => 'office_phone_label',
    :value => 'office',
    :agency_name => 'BarrioEarth Real Estate'
  },
  {
    :name => 'mobile_phone',
    :value => '+001 506 2244 8776',
    :agency_name => 'BarrioEarth Real Estate'
  },
  {
    :name => 'mobile_phone_label',
    :value => 'mobile',
    :agency_name => 'BarrioEarth Real Estate'
  },
  {
    :name => 'phone_contact_note',
    :value => 'Note: 506 is the country code for Costa Rica',
    :agency_name => 'BarrioEarth Real Estate'
  },
  {
    :name => 'email_note',
    :value => 'We respond to all inquiries within 24 hours',
    :agency_name => 'BarrioEarth Real Estate'
  },
  # BarrioEarth Heredia
  {
    :name => 'web_contact_note',
    :value => 'We respond to all inquiries within 48 hours',
    :agency_name => 'BarrioEarth Heredia'
  },
  {
    :name => 'office_phone',
    :value => '+001 506 2267 6865',
    :agency_name => 'BarrioEarth Heredia'
  },
  {
    :name => 'office_phone_label',
    :value => 'office',
    :agency_name => 'BarrioEarth Heredia'
  },
  {
    :name => 'mobile_phone',
    :value => '+001 506 8832 9146',
    :agency_name => 'BarrioEarth Heredia'
  },
  {
    :name => 'mobile_phone_label',
    :value => 'mobile',
    :agency_name => 'BarrioEarth Heredia'
  },
  {
    :name => 'phone_contact_note',
    :value => 'Note: 506 is the country code for Costa Rica',
    :agency_name => 'BarrioEarth Heredia'
  },
  {
    :name => 'email_note',
    :value => 'We respond to all inquiries within 24 hours',
    :agency_name => 'BarrioEarth Heredia'
  },
  # BarrioEarth Jacó
  {
    :name => 'web_contact_note',
    :value => 'We are neato',
    :agency_name => 'BarrioEarth Jacó'
  },
  {
    :name => 'office_phone',
    :value => '+001 506 2222 4444',
    :agency_name => 'BarrioEarth Jacó'
  },
  {
    :name => 'office_phone_label',
    :value => 'office',
    :agency_name => 'BarrioEarth Jacó'
  },
  {
    :name => 'mobile_phone',
    :value => '+001 506 8888 9999',
    :agency_name => 'BarrioEarth Jacó'
  },
  {
    :name => 'mobile_phone_label',
    :value => 'mobile',
    :agency_name => 'BarrioEarth Jacó'
  },
  {
    :name => 'phone_contact_note',
    :value => 'Note: 506 is the country code for Costa Rica',
    :agency_name => 'BarrioEarth Jacó'
  },
  {
    :name => 'email_note',
    :value => 'We respond fast',
    :agency_name => 'BarrioEarth Jacó'
  }
].each do |record|
  agency = Agency.find_by_name(record[:agency_name],
    :select => [ :id ]
  )
  next unless agency
  record.merge!(:agency_id => agency.id)
  record.merge!(:position => i + 1) unless record[:position]
  record.delete(:agency_name)
  key_value_hash = {}
  record.each_pair do |key, value|
    key_value_hash.merge!(key => value)
  end
  SiteText.create!(key_value_hash)
  i += 1
end
