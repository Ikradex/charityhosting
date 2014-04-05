class Charity < ActiveRecord::Base
  belongs_to :user
  has_many :pages
  has_many :animals
  has_many :posts
  has_many :donations
  has_many :lost_cases
  has_one :account

  before_save { self.domain = domain.downcase }

  # validates - ensures attribute conforms to specified constraints
  # unique domain, required
  validates :domain, presence: true, uniqueness: true
  # email format, required
  validates :email, presence: true, email_format: { message: "invalid format for email" },
    uniqueness: { case_sensitive: false },
    length: { minimum: 6, maximum: 320 }
  # organisation name, required, must be of length between 2 and 240 characters
  validates :org_name, presence: true, 
    length: { in: 2..240 },
    uniqueness: true
  # site template, required, must be of value 1, 2 or 3
  validates :template, presence: true, 
    inclusion: { in: 1..3 },
    numericality: { only_integer: true }

  # the charity model has images denoted by "avatar" and "banner_avtar"
  # we generate various sizes for our images so we can call any one of them
  has_attached_file :banner_avatar, :styles => { :large => "2100x300", :medium => "1200x300>", :thumb => "400x100" }, :default_url => "/images/:style/missing.png"
  has_attached_file :avatar, :styles => { :large => "450x450", :medium => "300x300", :thumb => "150x150" }, :default_url => "/images/:style/missing.png"
  # we're accepting any file as long as it's an image
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :banner_avatar, :content_type => /\Aimage\/.*\Z/

  # this allows us to save pages, account in the charity form
  # for nested resources
  accepts_nested_attributes_for :account, :pages
  validates_associated :pages

  def self.search( query )
    if query
      find( :all, :conditions => [ "org_name LIKE ?", "%#{query}%" ])
    end
  end

  def self.is_admin( user )
    if user
      user.id == self.user_id
    end
  end

  # override to_param to show domain name instead of id
  # eg /charities/catactiontrust rather than /charities/1
  def to_param
    domain
  end
end
