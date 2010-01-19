# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_barrioearth_session',
  :secret      => 'cc8cf8f1e003049343f90ac3068b06f7b52d55916793b754a0d2fd3f8ae1eb380c53b16baa49d5b04bb8dc613f2fb900649188a69bad28cc77caddeb80b3782c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
