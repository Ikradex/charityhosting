class AddCharityNumberVerifiedToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :charity_number_verified, :boolean
  end
end
