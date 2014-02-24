class Content < ActiveRecord::Base
  belongs_to :page

  validates :content_src, presence: true
end
