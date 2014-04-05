class AddNameToEnsnareViolation < ActiveRecord::Migration
  def change
    add_column :ensnare_violations, :name, :string
  end
end
