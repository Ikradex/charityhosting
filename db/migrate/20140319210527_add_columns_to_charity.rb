class AddColumnsToCharity < ActiveRecord::Migration
  def change
  	add_column :charities, :banner_image_id, :integer
  	add_column :charities, :logo_image_id, :integer
  end
end
