class AddAttachmentAvatarBannerAvatarToCharities < ActiveRecord::Migration
  def self.up
    change_table :charities do |t|
      t.attachment :avatar
      t.attachment :banner_avatar
    end
  end

  def self.down
    drop_attached_file :charities, :avatar
    drop_attached_file :charities, :banner_avatar
  end
end
