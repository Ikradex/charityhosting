class CreateTableLostCases < ActiveRecord::Migration
  def change
    create_table :table_lost_cases do |t|
    	t.string :owner_email
    	t.string :animal_name
    	t.string :description
    	t.integer :image_id
    end
  end
end
