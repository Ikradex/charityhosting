class AddColumnOwnerEmailToAnimal < ActiveRecord::Migration
  def change
    add_column :animals, :owner_email, :string
  end
end
