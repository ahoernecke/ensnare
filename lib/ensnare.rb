require "ensnare/engine"

module Ensnare
  mattr_accessor :type
  mattr_accessor :trap_on
  mattr_accessor :mode
  mattr_accessor :global_timer
  mattr_accessor :enabled_traps
  mattr_accessor :cookie_trap
  mattr_accessor :cookie_names
  mattr_accessor :randomizer
  mattr_accessor :predefined_cookies
  mattr_accessor :parameter_trap
  mattr_accessor :parameter_names
  mattr_accessor :predefined_parameters
  mattr_accessor :thresholds
  mattr_accessor :captcha_private_key
  mattr_accessor :captcha_public_key
  mattr_accessor :current_user_method
  mattr_accessor :current_user_identifier
  mattr_accessor :dashboard_user_method
  mattr_accessor :dashboard_authorization_method
  mattr_accessor :error_message
  mattr_accessor :warning_message
  mattr_accessor :testing

  def self.setup
    yield self

    foo = validate_config
    result = parse_thresholds
    
    unless Ensnare.error_message.nil?
      puts Ensnare.error_message
      exit(1)
    end
    puts Ensnare.warning_message
  end

  private


  def self.validate_config
    #Ensnare.error_message = ''
    Ensnare.warning_message = ""
    puts 'If you are having issues, please see the example configuration file located in: your_app/config/initalizers/ensnare.rb'
    puts 'Validating ensnare config...'
    # Check that these methods exist in the setup file
    begin
      no_method_check = [Ensnare.mode, Ensnare.trap_on, Ensnare.global_timer, Ensnare.enabled_traps]
    rescue Exception => e
      Ensnare.error_message = "no method error: " + e.message + ". You should have the following defined (exp. mode, trap_on, global_timer, enable_traps"
      return false
    end

    # Look for methods that Ensnare database knows about but are nil
    if Ensnare.mode.nil? || Ensnare.trap_on.nil? || Ensnare.global_timer.nil? || Ensnare.enabled_traps.nil?
      Ensnare.error_message = "nil settings found: are you sure you have defined mode, trap_on, global_timer, enable_traps?"
      return false
    end

    # Check if a mode is set for Ensnare
    unless [:enforce,:disable,:log].include?(Ensnare.mode)
      Ensnare.error_message = ":mode error: you must specify either :enforce, :disable, or :log"
      return false
    end

    # Check if user specified what to trap on
    begin
      Ensnare.trap_on.length.times do |i|
        unless [:ip, :user, :session].include?(Ensnare.trap_on[i])
          Ensnare.error_message = "trap_on error: you must specify :ip, :user, and/or :session"
          return false
        end
      end
    rescue
      Ensnare.error_message = "trap_on error: you must have a trap_on config setting"
      return false
    end

    # Checks to make sure a user idneitifer is set in conjunction with user method
    if (Ensnare.current_user_method.nil?) and (Ensnare.current_user_identifier.nil? == false)
      Ensnare.error_message = "current_user error: you cannot specificy an identifier without a user_method"
      return false
    end

    # Make sure the global timer is an integer if it's set
    unless Ensnare.global_timer.is_a? Integer
      Ensnare.error_message = "global_timer error: the global timer must be an integer"
      return false
    end

    # Check to make sure thresholds are defined
    if Ensnare.thresholds.length <= 0
      Ensnare.error_message = "thresholds error: you must have at least one threshold defined"
      return false
    end

    # Capture the largest timer from thresholds to compare global timer
    timers = []
    biggest_threshold_timer = ""
    # If thresholds do not have timers, throw an error
    Ensnare.thresholds.each do |t|
      if t[:timer].nil?
        Ensnare.error_message = "threshold timer error: are you sure you set timers in your thresholds?"
        return false
      else
        timers.push(t[:timer])
      end
    end

    # Threshold validations
    number_compare = 0
    begin
      responses = ["none", "message", "redirect", "redirect_loop", "throttle", "captcha", "not_found",
                   "server_error", "random_content", "block", "flash_error"]

      # Throw an error if no tresholds are found
      if Ensnare.thresholds.nil?
        Ensnare.error_message = "threshold error: no thresholds defined"
        return false
      end
      if Ensnare.thresholds.length <= 0
        Ensnare.error_message = "threshold error: no thresholds defined"
        return false
      end

      Ensnare.thresholds.length.times do |i|

        # Check that each threshold has a timer and it's valid
        if Ensnare.thresholds[i][:timer].nil?
          Ensnare.error_message = "threshold timer error: missing a threshold timer"
          return false
        end
        if Ensnare.thresholds[i][:timer] <= 0
          Ensnare.error_message = "threshold timer error: timer must be greater than 0"
          return false
        end

        # Check that each threshold has a trap_count and is valid
        if Ensnare.thresholds[i][:trap_count].nil?
          Ensnare.error_message = "trap_count : missing a trap_count"
          return false
        end
        if Ensnare.thresholds[i][:trap_count] <= 0
          Ensnare.error_message = "trap_count error: trap_count must be greater than 0"
          return false
        end

        # This check ensures that each subsequent threshold has a larger trap count
        if number_compare < Ensnare.thresholds[i][:trap_count]
          number_compare = Ensnare.thresholds[i][:trap_count]
        else
          Ensnare.error_message = "trap_count error: the threshold trap_count of " + Ensnare.thresholds[i][:trap_count].to_s +
            " is less then the previous trap_count of " + Ensnare.thresholds[i-1][:trap_count].to_s
          return false
        end

        # Check that the response type is valid based on the responses we have coded
        begin
          Ensnare.thresholds[i][:traps].length.times do |p|
            unless responses.include?(Ensnare.thresholds[i][:traps][p][:trap])
              Ensnare.warning_message += "response type #{Ensnare.thresholds[i][:traps][p][:trap]} is not a built-in response. You are on your own for validation!\n"              
            end
          end
        rescue Exception=>e
          puts "#{e.message} #{e.backtrace}"
          Ensnare.error_message = "trap threshold error: did you define any traps?"
          return false
        end
      end
    rescue
      Ensnare.error_message = "threshold parsing: unknown error"
      return false
    end

    # Check to make sure threshold timers are actually integers
    begin
      biggest_threshold_timer = timers.sort[-1]
    rescue
      Ensnare.error_message = "timer error: Check that you have integer timers set for thresholds"
      return false
    end

    # If global timer is smaller than biggest threshold timer, adjust and warn user
    begin
      if (Ensnare.global_timer <= biggest_threshold_timer)
        Ensnare.global_timer = biggest_threshold_timer + 3600
        Ensnare.warning_message += "global timer warning: global timer is too small, using " + Ensnare.global_timer.to_s + " as the default timer\n"
      end
    rescue
      # If the global timer isn't specified, set global timer to biggest threshold time plus 5 minutes
      Ensnare.global_timer = biggest_threshold_timer + 3600
      Ensnare.warning_message += "global timer warning: no timer specified, using " + Ensnare.global_timer.to_s + " as the default timer\n"
    end

    # Check to make sure at least one trap is enabled or configured
    if Ensnare.enabled_traps.length == 0
      Ensnare.error_message = "enabled traps error: You have no enabled traps defined"
      return false
    end

    # If something goes wrong when parsing enabled_traps, throw a generic error
    begin
      # This does not check for cookie_names or parameter_names
      # Is there a better way to pull in predefined defaults?
      predefined_defaults = [:admin, :random, :google, :uid, :gid, :debug]
      Ensnare.enabled_traps.length.times do |i|

        # Check if the trap type is built-in
        unless [:cookie,:parameter,:routing_error,:reg_ex].include?(Ensnare.enabled_traps[i][:type])
          Ensnare.warning_message += "trap type #{Ensnare.enabled_traps[i][:type]} is not a built-in type (:cookie, :parameter, :routing_error, :reg_ex). You are on your own for validation!\n"
        end


        begin
          # Check if predefined cookies are correct
          if Ensnare.enabled_traps[i][:type] == :cookie
            if (Ensnare.enabled_traps[i][:options][:cookie_names].nil?) and (Ensnare.enabled_traps[i][:options][:predefined_cookies].nil?)
              puts 'in here'
              # At least one predfeined cookie or custom cookie needs to be defined
              if (Ensnare.enabled_traps[i][:options][:cookie_names].length == 0) and (Ensnare.enabled_traps[i][:options][:predefined_cookies].length == 0)
                Ensnare.error_message = "no cookies error: you need either a cookie_name or predefined_cookie specified"
                return false
              end
            end
            Ensnare.enabled_traps[i][:options][:predefined_cookies].each do |cookie_defaults|
              unless predefined_defaults.include?(cookie_defaults)
                Ensnare.error_message = "predefined cookie error: FILL ME IN WITH COOKIES"
                return false
              end
            end
          end
        rescue
          Ensnare.error_message = "trap cookie error: Do you have options defined (exp. cookie_names or predefined_cookies?)"
          return false
        end

        begin
          if Ensnare.enabled_traps[i][:type] == :parameter
            # If both parameter_names and predefined_names are present, check to make sure that at least one has something defined
            if (Ensnare.enabled_traps[i][:options][:parameter_names].nil?) and (Ensnare.enabled_traps[i][:options][:predefined_parameters].nil?)
              if (Ensnare.enabled_traps[i][:options][:parameter_names].length == 0) and (Ensnare.enabled_traps[i][:options][:predefined_parameters].length == 0)
                Ensnare.error_message = "no parameters error: you need either a predefined_parameter or parameter_name specified"
                return false
              end
            end

            # If there are predefined_parameters, make sure they are really 'predefined'
            if (Ensnare.enabled_traps[i][:options][:predefined_parameters].length >= 0)
              Ensnare.enabled_traps[i][:options][:predefined_parameters].each do |parameter_defaults|
                unless predefined_defaults.include?(parameter_defaults)
                  Ensnare.error_message = "predefined parameter error: are you sure you have a valid parameter?"
                  return false
                end
              end
            end
          end
        rescue
          # General error catch for misconfigured parameters
          Ensnare.error_message = "Trap parameter error: Do you have options defined (exp. cookie_names or predefined_cookies?)"
          return false
        end
        # begin
        begin
          if Ensnare.enabled_traps[i][:type] == :routing_error
            Ensnare.enabled_traps[i][:options][:bad_paths].each do |path|
              unless /^\/[a-z0-9]+([\-\_]{1}[a-z0-9]+)*|\/[a-z0-9]+([\-\_]{1}[a-z0-9]+)?$/ =~ path
                Ensnare.warning_message += "routing warning: Invalid path (" + path + ") and will be ignored"
              end
            end
          end
        rescue Exception => e
          Ensnare.error_message = "Trap error: Do you have options and bad_paths defined?"
          return false
        end
      end
    rescue
      Ensnare.error_message = 'Trap types error: some sort of unkonwn error'
      return false
    end
    puts 'Validation succeeded.'
  end

  def self.parse_thresholds

    Ensnare.thresholds.each do |t|

      if(t[:traps].find_all{|x| x[:persist] != true}.map{|x| x[:weight]}.include?(nil))
        Rails.logger.error "No weight found. Defaulting to even weight"
        t[:traps].find_all{|x| x[:persist] != true}.each do |x|
          x[:weight] = 1
        end
      end

      total_weight = t[:traps].find_all{|x| x[:persist] != true}.map{|x| x[:weight]}.sum

      cumulative_weight = 0
      t[:traps].find_all{|x| x[:persist] != true}.each { |x|
        x[:weight] = cumulative_weight+=(1.0/total_weight)*x[:weight];
      }

    end

  end
end
