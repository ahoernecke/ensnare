class RenameViolationTypeField < ActiveRecord::Migration
  def change
	rename_column :ensnare_violations, :type, :violation_type
  end

end
