module Ensnare
  class Violation < ActiveRecord::Base
    attr_accessible :ip_address, :violation_type, :session_id, :user_id, :expected, :observed, :name, :weight

  end
end
