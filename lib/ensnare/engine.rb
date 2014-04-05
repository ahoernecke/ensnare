#require 'ensnare'
require 'ensnare/controllers/helpers'
require 'ensnare/form_tag_helper.rb'
require 'rails'
require "twitter-bootstrap-rails"
#require "recaptcha/rails"
require "ensnare/responses/response"
require "ensnare/traps/trap"


module Ensnare
  class Engine < ::Rails::Engine
    isolate_namespace Ensnare

    config.to_prepare do
      Dir[Rails.root + "lib/ensnare/responses/*.rb"].each {|file| require file }
      Dir[Rails.root + "lib/ensnare/traps/*.rb"].each {|file| require file }
      Dir[File.dirname(__FILE__)+ "/responses/*.rb"].each {|file| require file }
      Dir[File.dirname(__FILE__)+ "/traps/*.rb"].each {|file| require file }
    
    end

    initializer 'ensnare.app_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        #extend Ensnare::Controllers::Helpers::ClassMethods
        include Ensnare::Controllers::Helpers::InstanceMethods
      end
    end
  end
end
