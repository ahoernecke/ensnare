# log_only configuration file
Ensnare.setup do |config|

  # Config type
  config.type = :log_only

  # Settings to configure the operation mode of config.
  # Disable Ensnare from running.
  config.mode = :enforce

  # Log violation counts for both user account and IP address that triggers the trap
  config.trap_on = [:ip, :session, :user]


  config.current_user_method = :current_user
  config.current_user_identifier = :id

  # Identify authorized dashboard users
  config.dashboard_user_method = :current_user
  config.dashboard_authorization_method = :admin?

  # Sets the global violation timer (in seconds) which will reset
  # the violation count for the assocaited IP or user account.
  # This violation count resets after the suspicious IP or user account stops triggering traps.
  config.global_timer = 4000

  config.enabled_traps = [

    {:type=>:cookie,
     :options=>{
        # Specify an array of cookie names and their values you would like to use for your application.
        # If no cookie names are specified, you can select some predefined cookies with the next setting.

        # Select a predefined selection of cookie names.
        # :admin => this sets a cookie named admin with a boolean value set to false
        # :debug => this sets a cookie named debug with a boolean value set to false
        # :random => this generates a random N character cookie with a random encrypted value
        # :google => this generates 4 random cookies that look like Google tracking
        # :uid => this sets a cookie that look like a UID
        # :gid => this sets a cookie that looks like a GID
        :predefined_cookies=>[:random]
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
 },

    {:type=>:routing_error,
     :options=>{
      # Specify a list of paths to trigger traps on.  Very useful for detecting directory busting attacks
       :bad_paths=>["/admin", "/debug", "/robots", "/destory"],
       # Each trap has a weight of 10.  Instead of only resulting in one violation, this will count as 10!
       :violation_weight=>10
     }
     },
    {:type=>:reg_ex,
     :options=>{
      # Get crazy with the customizations here
       :reg_exs=>[/%3cscript%3e/i,/onerror/,/onmouseover/]
     }
     }
  ]

  # ####################### #
  # Configure Responses     #
  # ####################### #

  # These settings will help you configure how responses work within Ensnare.

  # Response Names:
  # => none
  # => message
  # => redirect
  # => redirect_loop
  # => throttle
  # => captcha
  # => not_found
  # => server_error
  # => random_content
  # => block


  # Response Overview

  # This section describes how resonses work and what settings you can specify.  Examples are shown in the violation
  # group configuration settings that describe how to group these together for ultimate annoyance!
  # You may notice each response has a weight.  You can use the weight attribute to create some randomness when grouping
  # these together.  If you set the weight to 0 on each response or don't set the weight at all, they will run in a
  # round robin fashion (aka fixed).

  # => none
  # This response does nothing at all!  Use this response to simply control the likelihood of responses being
  # triggered.  By setting the weight on this response higher, the likelihood of other responses being triggered when a violation
  # threshold is reached decreases.  This may help confuse an attacker and adds a bit of randomness.
  # => none settings

  # :weight => int(specify the likelihood of this response being triggered in a violation thresholds)


  # => message
  # This response displays a message you specify to warn the user to stop their malicious activity.
  # => message settings

  # :weight  => int(specify the likelihood of this response being triggered in a violation threshold)
  # :content => str(content to display in the warning message)


  # => redirect
  # This response simply redirects the user to either your webroot or a website you specify.  This seemingly
  # innocuous response can be very effective if setup on a violation threshold that includes multiple responses.

  # Imagine trying to navigate a website that intermittently redirects you out of the expected application flow.
  # This would make it very hard to attack multi step forms.
  # => redirect settings

  # :weight  => int(specify the likelihood of this response being triggered in a violation threshold)
  # :url => str(url or path to redirect the attacker to.  default is webroot)


  # => redirect_loop
  # The redirect loop response puts the IP or User account into an endless 301 loop.  This times out in most modern
  # browsers pretty quickly, however it fills up the proxy log (if the user is doing a manual attack) and
  # it is generally confusing. Often times, attackers will restart their web browsers or terminate a session
  # if an application exhibits this type of behavior.
  # => redirect_loop settings

  # :weight  => int(specify the likelihood of this response being triggered in a violation threshold)
  # :parameter => str(parameter to send nonce too)


  # => throttle
  # One of the most effective responses, the throttle implements a random or fixed delay time when requesting a page.
  # Long delays can result in application scanner instability and sometimes result
  # in false positives being generated such as time based sql injection.
  # => throttle settings

  # :weight  => int(specify the likelihood of this response being triggered in a violation threshold)
  # :min_delay => int(the minimum amount of time in seconds to delay the application when the response is triggered)
  # :max_delay => int(the maximum amount of time in seconds to delay the application when the response is triggered)
  # Note: you can set the min and max delay to the same time to create a fixed delay.


  # => captcha
  # One of the most effective responses for scanners, a captcha image must be solved before facilitating a request.
  # Long delays can result in application scanner instability and sometimes result
  # in false positives being generated such as time based sql injection.
  # The ensnare captcha reponses uses recaptcha which needs to be setup separately
  # Please see the recaptcha gem (https://github.com/ambethia/recaptcha/‎)
  # => throttle settings

  # :weight  => int(specify the likelihood of this response being triggered in a violation threshold)
  # :persist => boolean(if True, every request this function gets called until the user solves the captcha)
  # Note: We don't suggest you set weight AND persist.  This response is most effective when just set as persistent.

  # => not_found
  # This response will result in responses as a 404 page.
  # 404 pages may confuse application scanners about if the requested resource or request is valid.  Some scanners
  # may remove the request from scope if they receive 404 errors.
  # => 404 settings

  # :weight  => int(specify the likelihood of this resposne being triggered in a violation threshold)
  # :location => str(specify the location of the 404 page to display.  default is /public/404.html)


  # => server_error
  # This response sends a 500 page to as the response to a request.  500 errors are usually displayed when the
  # application framework cannot handle a request.  This can be especially lucrative for a manual attacker, who may
  # think he/she is effectively causing an application error.  This may result in the attacker spending unnecessary
  # time investigating a false positive.
  # => server_error settings

  # :weight  => int(specify the likelihood of this response being triggered in a violation threshold)
  # :location => str(specify the location of the 505 page to display.  default is /public/505.html)


  # => random_content
  # This response returns random content when triggered.
  # Simply used to confuse the manual attacker, garbled strings of varying length and nonsense will be returned.
  # => random_content settings

  # :weight  => int(specify the likelihood of this response being triggered in a violation threshold)
  # :min_size =>  int(specify the minimum size in bytes of the randomly generated response)
  # :max_size => int(specify the maximum size in bytes of the randomly generated response)


  # => block
  # This response blocks the IP address or user from accessing the site.  A blank page is returned with a
  # HTTP status code 200 and a content-length of 0.  This block happens for the duration of the violation threshold timer.
  # Very aggressive.
  # => block settings

  # :weight  => int(specify the likelihood of this response being triggered in a violation threshold)


  # ################################
  # Configure violation thresholds #
  # ################################

  # When a violation count gets triggered, the violation threshold activates, triggers a timer, and executes a response.
  # The timer resets each time an additional trap is triggered.  If the attacker backs off and the violation threshold timer
  # expires, the application will operate normally.  However, as soon as the attacker triggers another violation, the timer will
  # reset and the violation threshold group will resume.

  # You can setup multiple violation thresholds to be triggered when a threshold is hit.  This adds quite a bit of power into
  # really allowing the application to vary the trap responses to aid in confusion and hopefully thwart an attacker.


  # Threshold settings:

  # config.thresholds << {:timer=>int(time in seconds),
  #                      :violation_count=>int(amount of traps that need to be triggered to start the threshold),
  #                      :responses=>array[
  #                         {:response=>str(name of trap),options},
  #                         {:response=>str(name of trap),options}
  #                         ]}


  config.thresholds = []

  # Example 1:
  config.thresholds << {:timer=>60, :trap_count=>1,
                        :traps=>[
                          {:trap=>"random_content", :weight=>10, :min_size=>500, :max_size=>5000 },
                          {:trap=>"captcha", :persist=>true }
  ]}

  # This violation threshold group will run first and for 600 seconds if the violation count reaches 5 or higher.  Each time a trap is triggered,
  # the timer is reset. The redirect response will redirect a user to the root of the web appliation "/" 50% of the requests.  The web application will
  # delay responses randomly between 1 and 20 seconds 10% of the requests.  40% of the time, the application will behave
  # as expected (aka. the none trap response).


  # Example 2:

  config.thresholds << {:timer=>900, :trap_count=>10,
                        :traps=>[
                          {:trap=>"captcha", :persist=>true },
                          {:trap=>"redirect",:weight=>100,:url=>"/"}
                          
  ]}


  # This violation threshold group will run if the violation count reaches 15.  The timer will run for 900 seconds, and disable the
  # first violation group. Each time a trap is triggered, this timer is reset. A captcha image will occur on each request until the user solves the captcha.
  # If the captcha is solved, the follwoing events occur:
  # The throttle response will delay responses randomly between 15 and 20 seconds 30% of the time.
  # Not found will result in 404 error messages will occur 10% of requests.
  # Server error response will result in 500 error messages which will occur 20% of requests.
  # A redirect loop will occur 5% of the time.
  # Random content will be displayed with a length of 500 to 1500 bytes 5% of requests.
  # 20% of the time, the application will behave as expected.

  # # Example 3:

  config.thresholds << {:timer=>37000, :trap_count=>50,
                       :traps=>[
                          {:trap=>"block"}
                        ]}

  # This violation threshold group will run if the violation count reaches 75.  The timer will run for 1 hour and disable the
  # second threshold group. Each time a trap is triggered, this timer is reset. The application will block the associated
  # IP address or user account for the duration of the threshold.

end
