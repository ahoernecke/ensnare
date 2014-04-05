# This migration comes from ensnare (originally 20131121163305)
class AddWeightToViolations < ActiveRecord::Migration
  def change
    add_column :ensnare_violations, :weight, :integer
  end
end
