class LostCase < ActiveRecord::Base
	validates :owner_email, presence: true, email_format: { message: "invalid format for email" }
	validates :animal_name, presence: true
	validates :description, presence: true, length: { maximum: 400 }
end
