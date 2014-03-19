class AddTimestampsToPost < ActiveRecord::Migration
  def change
  	add_timestamps( :posts )
  end
end
