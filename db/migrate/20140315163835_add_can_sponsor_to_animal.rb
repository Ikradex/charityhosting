class AddCanSponsorToAnimal < ActiveRecord::Migration
  def change
    add_column :animals, :can_sponsor, :boolean
  end
end
