# Example
# user = User.create_or_update(:id => 1, :login => "admin", :email => "admin@example.com", 
#  :name => "Site Administrator", :password => "admin", :password_confirmation => "admin")
# role = Role.find_by_rolename('administrator')
# Permission.create_or_update(:id => 1, :role_id => role.id, :user_id => user.id)

country = Country.find_by_name('Costa Rica')

agency = Agency.create_or_update(
  :id => 1,
  :name => 'BarrioEarth Real Estate',
  :short_name => 'BarrioEarth',
  :country_id => country.id,
  :domain => 'barrioearth.com',
  :subdomain => 'rails',
  :master_agency => true,
  :email => 'realestate@barrioearth.com',
  :skype => 'barrioearth'
)

SiteText.create_or_update(
  :id => 1,
  :agency_id => agency.id,
  :name => 'web_contact_note',
  :value => 'We respond to all inquiries within 24 hours'
)

SiteText.create_or_update(
  :id => 2,
  :agency_id => agency.id,
  :name => 'office_phone',
  :value => '+001 506 244 8776'
)

SiteText.create_or_update(
  :id => 3,
  :agency_id => agency.id,
  :name => 'office_phone_label',
  :value => 'office'
)

SiteText.create_or_update(
  :id => 4,
  :agency_id => agency.id,
  :name => 'mobile_phone',
  :value => '+001 506 244 8776'
)

SiteText.create_or_update(
  :id => 5,
  :agency_id => agency.id,
  :name => 'mobile_phone_label',
  :value => 'mobile'
)

SiteText.create_or_update(
  :id => 6,
  :agency_id => agency.id,
  :name => 'phone_contact_note',
  :value => 'Note: 506 is the country code for Costa Rica'
)

SiteText.create_or_update(
  :id => 7,
  :agency_id => agency.id,
  :name => 'email_note',
  :value => 'We respond to all inquiries within 24 hours'
)

agency = Agency.create(
  :id => 1,
  :name => 'BarrioEarth Heredia',
  :short_name => 'Heredia',
  :country_id => country.id,
  :domain => 'barrioearth.com',
  :subdomain => 'heredia',
  :email => 'heredia@barrioearth.com',
  :skype => 'heredia'
)

SiteText.create_or_update(
  :id => 1,
  :agency_id => agency.id,
  :name => 'web_contact_note',
  :value => 'We reply to all inquiries within 48 hours'
)

SiteText.create_or_update(
  :id => 2,
  :agency_id => agency.id,
  :name => 'office_phone',
  :value => '506 244 8776'
)

SiteText.create_or_update(
  :id => 3,
  :agency_id => agency.id,
  :name => 'office_phone_label',
  :value => 'office'
)

SiteText.create_or_update(
  :id => 4,
  :agency_id => agency.id,
  :name => 'mobile_phone',
  :value => '506 244 8776'
)

SiteText.create_or_update(
  :id => 5,
  :agency_id => agency.id,
  :name => 'mobile_phone_label',
  :value => '506 385 6666'
)

SiteText.create_or_update(
  :id => 6,
  :agency_id => agency.id,
  :name => 'phone_contact_note',
  :value => 'Note: 506 is the country code for Costa Rica'
)

SiteText.create_or_update(
  :id => 7,
  :agency_id => agency.id,
  :name => 'email_note',
  :value => 'We will respond to your email within 48 hours'
)

agency = Agency.create(
  :id => 3,
  :name => 'BarrioEarth Jacó',
  :short_name => 'Jacó Beach',
  :country_id => country.id,
  :domain => 'barrioearth.com',
  :subdomain => 'jaco',
  :email => 'jaco_beach@barrioearth.com',
  :skype => 'jaco_beach_real_estate'
)

SiteText.create_or_update(
  :id => 1,
  :agency_id => agency.id,
  :name => 'web_contact_note',
  :value => 'We respond to all inquiries within 24 hours'
)

SiteText.create_or_update(
  :id => 2,
  :agency_id => agency.id,
  :name => 'office_phone',
  :value => '1 800 244 8776'
)

SiteText.create_or_update(
  :id => 3,
  :agency_id => agency.id,
  :name => 'office_phone_label',
  :value => 'toll free'
)

SiteText.create_or_update(
  :id => 4,
  :agency_id => agency.id,
  :name => 'mobile_phone',
  :value => '506 385 6969'
)

SiteText.create_or_update(
  :id => 5,
  :agency_id => agency.id,
  :name => 'mobile_phone_label',
  :value => 'mobile'
)

SiteText.create_or_update(
  :id => 6,
  :agency_id => agency.id,
  :name => 'phone_contact_note',
  :value => 'Note: 506 is the country code for Costa Rica'
)

SiteText.create_or_update(
  :id => 7,
  :agency_id => agency.id,
  :name => 'email_note',
  :value => 'What should this text say???'
)
