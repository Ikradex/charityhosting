class Animal < ActiveRecord::Base
  belongs_to :charities
  has_one :image

  validates :name, presence: true,
    length: { minimum: 2, maxiumum: 35 }
  validates :species, presence: true,
    length: { minimum: 2, maximum: 50 }

  validates :description, presence: true,
    length: { maximum: 160 }

  validates :owner_email, email_format: { message: "invalid format for email" },
    length: { minimum: 6, maximum: 320 }

  validates :breed, length: { maximum: 60 }
  validates :can_adopt, :can_sponsor, inclusion: { in: [ true, false ] }

  has_attached_file :avatar, :styles => { :large => "900x600", :medium => "450x300>", :thumb => "300x275" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentPresenceValidator, :attributes => :avatar

  def to_param
    name.downcase
  end
end
