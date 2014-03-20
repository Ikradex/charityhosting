class RenameTableLostCase < ActiveRecord::Migration
  def change
  	rename_table :table_lost_cases, :lost_cases
  end
end
