class AddContentToPost < ActiveRecord::Migration
  def change
    add_column :posts, :post_content, :text
  end
end
