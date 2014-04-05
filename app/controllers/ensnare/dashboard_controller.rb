require_dependency "ensnare/application_controller"

module Ensnare
  class DashboardController < ApplicationController
    layout 'ensnare/dashboard'
    
    def mode
      #render mode erb, read config file and toggle switches
      @mode = Ensnare.mode
      @timer = Ensnare.global_timer
    end

    def metrics
      #@violations = Ensnare::Violation.where("created_at >= ?", Time.now-Ensnare.global_timer.seconds)
      @violations = Ensnare::Violation.all

      @violations_by_type= Ensnare::Violation.group(:violation_type).limit(params[:limit]||25).offset(params[:offset]||0).count(:order=>"count_all desc")
      @violations_by_ip = Ensnare::Violation.group(:ip_address).limit(params[:limit]||25).offset(params[:offset]||0).count(:order=>"count_all desc")
      @violations_by_session = Ensnare::Violation.group(:session_id).limit(params[:limit]||25).offset(params[:offset]||0).count(:order=>"count_all desc")
      @violations_by_user_id = Ensnare::Violation.group(:user_id).limit(params[:limit]||25).offset(params[:offset]||0).count(:order=>"count_all desc")

    end

    def configs
      @timer = Ensnare.global_timer
    end

    def violations
      @violations = Ensnare::Violation.order("created_at DESC").limit(100)
    end


  end
end
