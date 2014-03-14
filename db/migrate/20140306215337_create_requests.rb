class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
       t.string :domain
      t.string  :org_name
      t.string  :email
      t.integer :template
      t.integer :charity_number
      t.boolean :charity_number_verified
      t.string  :org_address
      t.string  :org_tel
      t.timestamps
    end
  end
end
