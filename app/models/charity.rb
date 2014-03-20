class Charity < ActiveRecord::Base
  belongs_to :user
  has_one :account
  has_many :pages
  has_many :animals
  has_many :posts

  has_attached_file :image

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

  # this allows us to save pages, account in the charity form
  # for nested resources
  accepts_nested_attributes_for :account, :pages
  validates_associated :pages

  def self.search( query )
    if query
      find( :all, :conditions => [ "org_name LIKE ?", "%#{query}%" ])
    end
  end

  # override to_param to show domain name instead of id
  # eg /charities/catactiontrust rather than /charities/1
  def to_param
    domain
  end
end
