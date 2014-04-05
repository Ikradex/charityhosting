class Page < ActiveRecord::Base
  belongs_to :charity
  has_one :content

  # friendly urls
  before_save { self.title = title.downcase.tr( " ", "-" ) }

  # eg. page names unique only to their parent charity
  validates :title, uniqueness: { scope: :charity }, presence: true, length: { minimum: 3, maximum: 20 }

  # allows us to handle content creation inside a page
  accepts_nested_attributes_for :content

  def to_param
    title
  end
end
