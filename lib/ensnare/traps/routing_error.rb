# This trap will determine if a bad path was visited by the user.
# This trap requires settings up a route to allow ensnare to handle 404s
# A list of admin paths can be configured to only trigger a trap on certain paths (/admin for example)


class Ensnare::Trap::RoutingError < Ensnare::Trap::Trap
    def initialize(controller_name,action_name, session, parameters, cookies, request, user_id, options={})
        super(controller_name, action_name, session, parameters, cookies, request, user_id, options)
        @violation_type = "Routing Error"
    end



    def run
        violations = []

        if(@controller_name == "violations" && @action_name == "routing_error" && (@options[:bad_paths] == nil || @options[:bad_paths].include?(@request.path)))
            violations << log_violation(@request.path, "", "")
            
        end

        
        violations
    end
end