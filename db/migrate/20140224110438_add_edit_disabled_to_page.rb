class AddEditDisabledToPage < ActiveRecord::Migration
  def change
    add_column :pages, :edit_disabled, :boolean
  end
end
