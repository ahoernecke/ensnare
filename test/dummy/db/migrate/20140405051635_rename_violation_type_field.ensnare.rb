# This migration comes from ensnare (originally 20131007210137)
class RenameViolationTypeField < ActiveRecord::Migration
  def change
	rename_column :ensnare_violations, :type, :violation_type
  end

end
