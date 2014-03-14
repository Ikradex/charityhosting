class AddOrgAddressToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :org_address, :string
  end
end
