class Post < ActiveRecord::Base
  belongs_to :charity
  belongs_to :user

  validates :title, presence: true, length: { minimum: 3 }
  validates :summary, length: { maximum: 160 }
  validates :post_content, presence: true
end
