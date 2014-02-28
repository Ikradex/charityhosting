class AddCharityNumberToCharity < ActiveRecord::Migration
  def change
    add_column :charities, :charity_number, :integer
  end
end
