module Ensnare
    module Response
        class Response 
            
            def initialize(controller, session, violations, flash, options={})
                @controller = controller
                @options = options
                @violations = violations
                @session = session
                @flash = flash
            end


            def run

            end
        end
    end
end