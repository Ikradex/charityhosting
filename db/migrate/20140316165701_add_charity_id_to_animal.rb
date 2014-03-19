class AddCharityIdToAnimal < ActiveRecord::Migration
  def change
    add_column :animals, :charity_id, :integer
  end
end
