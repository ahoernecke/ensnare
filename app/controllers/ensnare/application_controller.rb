module Ensnare
  class ApplicationController < ActionController::Base
    before_filter :check_privileges

    def check_privileges
      
      if(Ensnare.dashboard_user_method.present? && Ensnare.dashboard_authorization_method.present?)
        user = send(Ensnare.dashboard_user_method)
        is_admin = user.try(:send,Ensnare.dashboard_authorization_method)
        
        if(is_admin != true)

          Rails.logger.error "Unauthorized access attempt: Configure dashboard access with Ensnare.dashboard_user_method option."
          raise ActionController::RoutingError.new('Not Found')
        end
      else
        Rails.logger.error "Dashboard access requires configuration of Ensnare.dashboard_user_method option"
        raise ActionController::RoutingError.new('Not Found')
      end
    end
  end
end
