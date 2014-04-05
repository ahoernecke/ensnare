module Ensnare
  module Controllers
    module Helpers
      module InstanceMethods

        def ensnare
          Rails.logger.debug("I am running!!")

          violations = []

          if(Ensnare.current_user_method)
            user = method(Ensnare.current_user_method).call unless !respond_to?(Ensnare.current_user_method)
            if(user && Ensnare.current_user_identifier)
              user = user.send(Ensnare.current_user_identifier)
            end
          end

          if(Ensnare.mode == :enforce || Ensnare.mode == :log)
            Rails.logger.debug("Enabled traps: #{Ensnare.enabled_traps.inspect}")
            Ensnare.enabled_traps.each do |t|
              Rails.logger.debug("Trap: #{t.inspect}")
              trap_type = t[:type]
              trap_options = t[:options]
              violations.concat(
                ("Ensnare::Trap::" + trap_type.to_s.classify).constantize.new(controller_name, action_name, session, params, cookies, request, user, trap_options).run
              )

            end

            if(Ensnare.mode == :enforce)
              enforce_violations(violations)
            end

          end
        end

        def enforce_violations(new_violations)
          if(new_violations.blank?)
            Rails.logger.debug "There were NO new violations identified this request: " + new_violations.inspect
          else
            Rails.logger.debug "There WERE new violations identified this request: " + new_violations.inspect
          end

          violations=nil

          conditions = {}
          conditions[:ip_address] = request.remote_ip if [*Ensnare::trap_on].include?(:ip)
          conditions[:session_id] = session["session_id"] if (session.try(:[],"session_id").present? && [*Ensnare::trap_on].include?(:session))



          if(Ensnare.current_user_method)
            user = method(Ensnare.current_user_method).call
            if(user && Ensnare.current_user_identifier)
              user = user.send(Ensnare.current_user_identifier)
            end
          end

          conditions[:user_id] = user if (user && [*Ensnare::trap_on].include?(:user))

          query = conditions.map{|k,v| "#{k} = ?"}.join(" OR ")

          Rails.logger.debug query.to_s

          violations = Ensnare::Violation.where(query, *conditions.map{|k,v| v.to_s})
          .where("created_at > ?",Ensnare.global_timer != nil ? Time.now - Ensnare.global_timer.seconds : Time.now - 24.hours)
          .order("created_at desc")


          if(!violations.blank?)
            violation_count = violations.sum(:weight)
            last_violation_time = violations.first.created_at
            Rails.logger.debug("*** Violations identified (#{violation_count})")


            threshold = Ensnare.thresholds.find_all{|x| x[:trap_count] <= violation_count}.max_by{|x| x[:trap_count] }

            if(threshold && Time.now - last_violation_time <= threshold[:timer])
              Rails.logger.debug("*** Violations found on threshold: " + threshold.to_s)
              process_violation(threshold, new_violations)
            end
          else
            Rails.logger.debug("*** No violations found")

          end
        end



        private




        def process_violation(threshold, new_violations)

          persistent_responses = threshold[:traps].find_all{|x| x[:persist] == true}
          random_response = threshold[:traps].find{ |x| (x[:persist] != true && x[:weight] >= Random.rand)}


          persistent_responses.each do |r|
            trap_response=nil
            Rails.logger.debug "Going to run persistent trap: #{r[:trap]}"
            begin
              trap_response = ("Ensnare::Response::" + r[:trap].to_s.classify).constantize.new(self, session, new_violations, flash, r)
            rescue
              Rails.logger.error "Could not find persistent response type: #{r[:trap]}"
              trap_response = nil
            end

            if(trap_response)
              Rails.logger.debug("Running...")
              if(trap_response.run == true)
                Rails.logger.debug("A response has rendered. Returning...")
                return
              end
            end

          end

          trap_response=nil
          if(random_response)
            Rails.logger.debug "Going to run trap: #{random_response[:trap]}"

            begin
              trap_response = ("Ensnare::Response::" + random_response[:trap].to_s.classify).constantize.new(self, session, new_violations, flash, random_response)
            rescue
              Rails.logger.error "Could not find response type: #{random_response[:trap]}"
              trap_response = nil
            end
            if(trap_response)
              Rails.logger.debug("Running...")
              if(trap_response.run == true)
                Rails.logger.debug("A response has rendered. Returning...")
                return
              end
            end
          end
        end
      end
    end
  end
end
