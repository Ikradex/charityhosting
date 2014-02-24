class Charity < ActiveRecord::Base
	belongs_to :user
	has_one :account
	has_many :pages

	before_save { self.domain = domain.downcase }
	#before_save :get_domain

	validates :domain, presence: true, uniqueness: true
	validates :email, presence: true, email_format: { message: "invalid format for email" }
	validates :org_name, presence: true, length: { in: 2..120 }
	validates :template, presence: true, inclusion: { in: 1..3 }

	accepts_nested_attributes_for :account, :pages

	def get_domain
		#self.domain = URI.parse( domain ).host
	end

	#override to_param to show domain name instead of id
	def to_param
		domain
	end
end
