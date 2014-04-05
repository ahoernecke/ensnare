class Ensnare::Trap::Cookie < Ensnare::Trap::Trap
    def initialize(controller_name, action_name, session, parameters, cookies, request, user_id, options={})
        super(controller_name, action_name, session, parameters, cookies, request, user_id, options)
        @violation_type = "Cookie"
    end

    def run        
        violations = []
        
        
        cookie_hash = @session.try(:[],:ensnare).try(:[],:cookies) || {}
        cookie_hash.each do |k,v|
        
            if(@cookies[k.to_s] != v.to_s)
                Rails.logger.debug("Trap Triggered. REASON: Cookie violation detected. IP:" + @request.remote_ip.to_s)
                violations <<  log_violation(k.to_s, v.to_s, @cookies[k.to_s].to_s)

                
            end
        end

        setup_cookies

        violations
    end

    private 

    def setup_cookies
        Rails.logger.debug("Setting up cookies")

        @session[:ensnare] ||= {}
        @session[:ensnare][:cookies] ||= {}


        if(@options[:cookie_names].class == Hash)
            @options[:cookie_names].each do |k,v|
                @cookies[k.to_s] = v.to_s
                @session[:ensnare][:cookies][k.to_s] = v.to_s
            end
        end


        if(@options[:predefined_cookies].class == Array)
            @options[:predefined_cookies].each do |c|
                case c
                when :admin
                    cookies = {"admin" => "false"}
                when :debug
                    cookies = {"debug" => "false"}
                    
                when :random
                    #This is set to a pre-set "random" string for now. Would be nice to have this generated on the fly
                    k= 'vnenSdjfxLgjFDSra' 
                    v= @session[:ensnare][:cookies][k.to_s] || SecureRandom.urlsafe_base64(40)
                    cookies = {k => v}
                when :google
                    
                    cookies = {
                        "__utma" => (0...7).map{ ('0'..'9').to_a[rand(10)] }.join + "." +
                            (0...9).map{ ('0'..'9').to_a[rand(10)] }.join + "." +
                            (0...10).map{ ('0'..'9').to_a[rand(10)] }.join + "." +
                            (0...10).map{ ('0'..'9').to_a[rand(10)] }.join + "." +
                            (0...2).map{ ('0'..'9').to_a[rand(10)] }.join ,
                        "__utmb" => (0...8).map{ ('0'..'9').to_a[rand(10)] }.join + "." +
                            (0...1).map{ ('0'..'9').to_a[rand(10)] }.join + "." +
                            (0...2).map{ ('0'..'9').to_a[rand(10)] }.join + "." +
                            (0...10).map{ ('0'..'9').to_a[rand(10)] }.join ,
                        "__utmc" => (0...7).map{ ('0'..'9').to_a[rand(8)] }.join ,
                        "__utmv" => (0...8).map{ ('0'..'9').to_a[rand(10)] }.join + ".lang%3A%20en" ,
                        "__utmz" =>  (0...8).map{ ('0'..'9').to_a[rand(10)] }.join + "." +
                            (0...10).map{ ('0'..'9').to_a[rand(10)] }.join + "." +
                            (0...1).map{ ('0'..'9').to_a[rand(10)] }.join + "." +
                            (0...1).map{ ('0'..'9').to_a[rand(10)] }.join + "." +
                            "utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)"
                    }

                when :uid
                    k="uid"
                    v= @session[:ensnare][:cookies][k.to_s] || SecureRandom.urlsafe_base64(25)
                    cookies =  {k => v}

                when :gid
                    k="gid"
                    v= @session[:ensnare][:cookies][k.to_s] || SecureRandom.urlsafe_base64(25)
                    cookies =  {k => v}
                end

                cookies.each do |key,value|
                    @cookies[key.to_s] = value.to_s
                    @session[:ensnare][:cookies][key.to_s] = value.to_s
                end

            end
        end

    end
end