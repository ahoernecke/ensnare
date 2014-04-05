class Widget < ActiveRecord::Base
  attr_accessible :description, :name
#  include Ensnare::MassAssignmentSecurity
end
