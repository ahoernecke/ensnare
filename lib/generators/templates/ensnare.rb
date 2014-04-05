# log_only configuration file
Ensnare.setup do |config|

  # Config type
  config.type = :log_only

  # Settings to configure the operation mode of config.
  # Disable Ensnare from running.
  config.mode = :log

  # Log violation counts for both user account and IP address that triggers the trap
  config.trap_on = :ip

  # Identify authorized dashboard users
  # config.dashboard_user_method = :current_user
  # config.dashboard_authorization_method = :admin?

  # Sets the global violation timer (in seconds) which will reset
  # the violation count for the assocaited IP or user account.
  # This violation count resets after the suspicious IP or user account stops triggering traps.
  config.global_timer = 4000

  # Cookie Trapping:
  # Enable trap cookies on requests.
  config.cookie_trap = true

  # :admin => this sets a cookie named admin with a boolean value set to false
  # :debug => this sets a cookie named debug with a boolean value set to false
  # :random => this generates a random N character cookie with a random encrypted value
  # :google => this generates 4 random cookies that look like Google tracking
  # :uid => this sets a series of cookies that look like UIDs and GIDs
  config.predefined_cookies = [:debug, :random]

  # Parameter Trapping:
  # Enable trap parameters on form POST.
  config.parameter_trap = true

  # :admin => this sets a cookie named admin with a boolean value set to false
  # :debug => this sets a cookie named debug with a boolean value set to false
  # :random => this cookie generates a random N character cookie with a random encrypted value
  # :uid => this sets a series of parameters that look like UIDs and GIDs
  config.predefined_cookies = [:uid]

end