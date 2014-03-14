class AddOrgTelToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :org_tel, :string
  end
end
