class Post < ActiveRecord::Base
	belongs_to :charity
	belongs_to :user
	has_one :content

	validates :title, presence: true, length: { minimum: 3 }
end
