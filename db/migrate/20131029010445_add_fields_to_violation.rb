class AddFieldsToViolation < ActiveRecord::Migration
  def change
    add_column :ensnare_violations, :session_id, :string
    add_column :ensnare_violations, :user_id, :string
    add_column :ensnare_violations, :expected, :string
    add_column :ensnare_violations, :observed, :string
  end
end
