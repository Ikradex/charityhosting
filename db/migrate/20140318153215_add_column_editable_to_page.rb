class AddColumnEditableToPage < ActiveRecord::Migration
  def change
    add_column :pages, :editable, :boolean
  end
end
