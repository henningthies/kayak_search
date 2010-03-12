# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kayak_session',
  :secret      => '58e695abea52eaa25dcab0f13a379cd61367a15b8f3bfefe3e35dc2162748599a486e4060df7fe14f75101c7cfa5d87dc28306184d28e4559d178dd02e705e5b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
