class AddTemplateToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :template, :integer
  end
end
