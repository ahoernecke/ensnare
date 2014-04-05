class Ensnare::Trap::Parameter < Ensnare::Trap::Trap
    def initialize(controller_name, action_name, session, parameters, cookies, request, user_id, options={})
        super(controller_name, action_name, session, parameters, cookies, request, user_id, options)
        @violation_type = "Parameter"
    end


    def run
        violations = []
        model = @controller_name.tableize.singularize.to_sym

        Rails.logger.debug "Running parameter trap"
        Rails.logger.debug "controller: #{@controller_name}"
        Rails.logger.debug "action: #{@action_name}"
        Rails.logger.debug "session: #{@session}"
        Rails.logger.debug "parameters: #{@parameters}"
        Rails.logger.debug "cookies: #{@cookies}"
        Rails.logger.debug "request: #{@request}"
        Rails.logger.debug "user_id: #{@user_id}"
        Rails.logger.debug "options: #{@options}"

        @options[:predefined_parameters] ||= []
        @options[:parameter_names] ||= []

        @options[:predefined_parameters].each do |p|
            tampered_parameter = false

            if(@parameters.try(:[],model).try(:[],p.to_s))

                ##test_param = @parameters[model][p.to_s]
                
                test_param = deep_find p.to_s, @parameters
                
                case p
                when :admin
                    expected = "false"
                when :debug
                  expected = "false"
                when :random
                  expected =  @session.try(:[],:ensnare).try(:[],:params).try(:[],"random") 
                when :gid
                  expected =  @session.try(:[],:ensnare).try(:[],:params).try(:[],"gid")
                when :uid
                  expected =  @session.try(:[],:ensnare).try(:[],:params).try(:[],"uid")
                end
                Rails.logger.debug "Checking parameter #{p}. Value #{test_param} Expected: #{expected}"

                if(test_param != expected)
                    Rails.logger.debug("VIOLATION! Parameter tampering. Parameter: #{p.to_s} Observed: #{test_param.to_s} Expected: #{expected.to_s} IP:" + @request.remote_ip.to_s)
                    puts "Session id: #{@session["session_id"]}"
                    violations <<  log_violation(p.to_s, expected.to_s, test_param.to_s)

                    
                end
                #@parameters[model].delete(p.to_s)
            end
        end

        @options[:parameter_names].each do |k,v|
            test_param = deep_find k.to_s, @parameters
            if(test_param)
                #test_param = @parameters.try(:[],model).try(:[],k.to_s)
                
                expected = @session.try(:[],:ensnare).try(:[],:params).try(:[],k.to_s).to_s
                if(test_param.to_s != expected.to_s)
                    Rails.logger.debug("VIOLATION! Parameter tampering. Parameter: #{k.to_s} Observed: #{test_param.to_s} Expected: #{expected.to_s} IP:" + @request.remote_ip.to_s)
                    violations <<  log_violation(k.to_s, expected.to_s, test_param.to_s)
                end
                #@parameters[model].delete(k.to_s)
            end
        end
        violations
    end


    private 

     def deep_find(key, object=self, found=nil)
        if object.respond_to?(:key?) && object.key?(key)
          return object.delete(key)
        elsif object.is_a? Enumerable
          object.find { |*a| found = deep_find(key, a.last) }
          return found
        end
      end


end