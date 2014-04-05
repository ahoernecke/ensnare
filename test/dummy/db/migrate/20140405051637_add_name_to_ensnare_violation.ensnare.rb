# This migration comes from ensnare (originally 20131031001835)
class AddNameToEnsnareViolation < ActiveRecord::Migration
  def change
    add_column :ensnare_violations, :name, :string
  end
end
