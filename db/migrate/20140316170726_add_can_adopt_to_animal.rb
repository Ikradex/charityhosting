class AddCanAdoptToAnimal < ActiveRecord::Migration
  def change
    add_column :animals, :can_adopt, :boolean
    add_column :animals, :name, :string
    add_column :animals, :species, :string
    add_column :animals, :breed, :string
  end
end
