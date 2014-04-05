# This migration comes from ensnare (originally 20131007205246)
class CreateEnsnareViolations < ActiveRecord::Migration
  def change
    create_table :ensnare_violations do |t|
      t.string :ip_address
      t.string :type

      t.timestamps
    end
  end
end
