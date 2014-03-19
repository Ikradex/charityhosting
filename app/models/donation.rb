class Donation < ActiveRecord::Base
	validates :email, presence: true, email_format: { message: "invalid format for email" }
	validates :amount, presence: true, numericality: { only_integer: false }
	validates :token, presence: true
end
