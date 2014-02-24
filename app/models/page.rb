class Page < ActiveRecord::Base
  belongs_to :charity
  has_one :content

  before_save { self.title = title.downcase.tr( " ", "_" ) }

  # names/titles for pages are unique only to scope of charity
  # wouldn't make sense if "index" could only be used once ever
  validates :title, uniqueness: { scope: :charity }, presence: true, length: { minimum: 3, maximum: 20 }

  accepts_nested_attributes_for :content

  def to_param
    title
  end
end
