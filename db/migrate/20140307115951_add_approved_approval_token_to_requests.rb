class AddApprovedApprovalTokenToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :approved, :boolean
    add_column :requests, :approval_token, :string
  end
end
