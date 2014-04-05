class Ensnare::Trap::RegEx < Ensnare::Trap::Trap
    def initialize(controller_name, action_name, session, parameters, cookies, request, user_id, options={})
        super(controller_name, action_name, session, parameters, cookies, request, user_id, options)
        @violation_type = "RegEx"
    end

    def run        
        violations = []

        Rails.logger.debug "Query string: #{@request.query_string}  POST Data: #{@request.raw_post}"

        @options[:reg_exs].each do |regex|
            query_matches = @request.query_string.to_s.match(regex)
            if(query_matches)
                violations << log_violation("Query String", query_matches[0], regex.to_s)
            end

            post_matches = @request.raw_post.to_s.match(regex)
            if(post_matches)
                violations << log_violation("Post Data", post_matches[0], regex.to_s)
            end
        end
        
        violations
    end
end