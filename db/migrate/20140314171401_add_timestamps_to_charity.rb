class AddTimestampsToCharity < ActiveRecord::Migration
  def change
  	add_timestamps( :charities )
  end
end
