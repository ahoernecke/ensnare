# log_only configuration file
Ensnare.setup do |config|

# Config type
config.type = :log_only

# Settings to configure the operation mode of config.
# Disable Ensnare from running.
config.mode = :log

# Log violation counts for both user account and IP address that triggers the trap
config.trap_on = [:ip, :session]


 
# Identiifes the method used to retrieve the currently logged-in user object/id
## config.current_user_method = :current_user

# Identifies the method/attribute on the user object (returned when the defined current_user_method is run)
  # that should be used to uniquely identify the user. So for example, if you can get the currently logged
  # in user's id by calling current_user.id, the "current_user_method" should be set to :current_user
  # and the "current_user_identifier" should be set to :id. If the current_user_method itself returns
  # the appropriate identifer (such as an id value or username) then the "current_user_identifier"
  # does not need to be specified. Additionally, if the application does not have the concept of users,
  # or if you do not want to track violations by user, the "current_user_method" can also remain unspecified
## config.current_user_identifier = :id

# Identiifes the method used to retrieve the currently logged-in admin user object/id
## config.dashboard_user_method = :current_user

# Identifies the method/attribute on the admin user object used to determine if the user has authorization to view the dashboard
  # For example, if the dashboard_user_method is set to :current_user and the dashboard_user_identifier is set to :admin
  # Ensnare will check for authorization by calling current_user.admin?
## config.dashboard_user_identifier = :admin?

# Sets the global violation timer (in seconds) which will reset
# the violation count for the assocaited IP or user account.
# This violation count resets after the suspicious IP or user account stops triggering traps.
config.global_timer = 4000

config.enabled_traps = [
{:type=>:cookie,
 :options=>{
    # :admin => this sets a cookie named admin with a boolean value set to false
    # :debug => this sets a cookie named debug with a boolean value set to false
    # :random => this generates a random N character cookie with a random encrypted value
    # :google => this generates 4 random cookies that look like Google tracking
    # :uid => this sets a cookie that look like a UID
    # :gid => this sets a cookie that looks like a GID

    :predefined_cookies=>[:uid]
 }
 },
{:type=>:parameter,
 :options=>{
    # Select a predefined selection of parameter names.
    # :admin => this sets a cookie named admin with a boolean value set to false
    # :debug => this sets a cookie named debug with a boolean value set to false
    # :random => this cookie generates a random N character cookie with a random encrypted value
    # :uid => this sets a cookie that look like a UID
    # :gid => this sets a cookie that looks like a GID

    :predefined_parameters=>[:debug, :random]
 }
 }
]

# No threshold/responses configured since we're in log only mode
  config.thresholds = []

  config.thresholds << {:timer=>1000, :trap_count=>100,
                        :traps=>[
                          {:trap=>"none",:weight=>100}
  ]}
end