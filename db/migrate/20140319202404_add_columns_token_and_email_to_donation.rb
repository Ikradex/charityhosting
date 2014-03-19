class AddColumnsTokenAndEmailToDonation < ActiveRecord::Migration
  def change
  	add_column :donations, :token, :string
  	add_column :donations, :email, :string
  	add_column :donations, :charity_id, :integer
  end
end
