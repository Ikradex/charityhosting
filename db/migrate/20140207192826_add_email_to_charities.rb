class AddEmailToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :email, :string
  end
end
