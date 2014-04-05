class AddWeightToViolations < ActiveRecord::Migration
  def change
    add_column :ensnare_violations, :weight, :integer
  end
end
