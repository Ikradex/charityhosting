class DropTableLostCases < ActiveRecord::Migration
  def change
  	drop_table :lost_cases
  end
end
