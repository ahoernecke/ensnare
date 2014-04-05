module Ensnare
    module Trap
        class Trap
            
            def initialize(controller_name, action_name, session, parameters, cookies, request, user_id, options={})
                @controller_name = controller_name
                @action_name = action_name
                @session = session
                @parameters = parameters
                @cookies = cookies
                @request = request
                @user_id = user_id
                @options = options
                @violation_type = ""
            end


            def run

            end

            private

            def log_violation(name, expected, observed)
                Ensnare::Violation.create(:ip_address=>@request.remote_ip.to_s, 
                        :violation_type=>@violation_type,
                        :session_id=>@session.try(:[],"session_id").to_s,
                        :user_id=>@user_id,
                        :expected=>expected,
                        :name=>name,
                        :observed=>observed,
                        :weight=>@options[:violation_weight] || 1)
            end
        end
    end
end