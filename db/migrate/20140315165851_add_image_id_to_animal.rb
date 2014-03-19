class AddImageIdToAnimal < ActiveRecord::Migration
  def change
    add_column :animals, :image_id, :integer
  end
end
