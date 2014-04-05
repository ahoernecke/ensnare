require 'rails/generators/base'

module Ensnare
  class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
    
    def copy_initializer
        template "ensnare.rb", "config/initializers/ensnare.rb"
    end

  end 
end