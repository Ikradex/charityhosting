class LostCase < ActiveRecord::Base
	validates :owner_email, presence: true, email_format: { message: "invalid format for email" }
	validates :animal_name, presence: true
	validates :description, presence: true, length: { maximum: 400 }

	has_attached_file :avatar, :styles => { :large => "900x600", :medium => "450x300>", :thumb => "300x275" }, :default_url => "/images/:style/missing.png"
  	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  	validates_with AttachmentPresenceValidator, :attributes => :avatar
end
