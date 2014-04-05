class AddAttachmentAvatarToLostCases < ActiveRecord::Migration
  def self.up
    change_table :lost_cases do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :lost_cases, :avatar
  end
end
