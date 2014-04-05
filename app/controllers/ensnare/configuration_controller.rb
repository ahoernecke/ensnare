require_dependency "ensnare/application_controller"

module Ensnare
  class ConfigurationController < ApplicationController
  layout 'ensnare/dashboard'

    def change_mode
      if( %w[enforce disabled log].include?(params[:mode]))
        Ensnare.mode = params[:mode].to_sym
      end

      redirect_to mode_path
    end

  end
end
