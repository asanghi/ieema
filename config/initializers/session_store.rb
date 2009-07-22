# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ieema_session',
  :secret      => '6716056bc93c32b7dcf06c9e3c71058be39199f22cd190af47bd351cdab4be2b944d29b0cd3c1ece10b0b9ec9fd558685bf18796a6f43172bcb70aec33f6a943'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
