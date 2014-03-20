class AddColumnCharityIdToLostCases < ActiveRecord::Migration
  def change
  	add_column :lost_cases, :charity_id, :integer
  end
end
