class User < ActiveRecord::Base
	has_many :charities
	has_many :posts

	before_save { self.email = email.downcase }

	validates :email, email_format: { message: "invalid format for email" }, 
				uniqueness: { case_sensitive: false },
				presence: true, 
				confirmation: true
	validates :f_name, presence: true, length: { minimum: 2 }
	validates :l_name, presence: true, length: { minimum: 2 } 

	has_secure_password # jesus, this is all we need to hash a new password?
	validates :password, presence: true, length: { minimum: 6 }
end
