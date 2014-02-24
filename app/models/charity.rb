class Charity < ActiveRecord::Base
  belongs_to :user
  has_one :account
  has_many :pages

  before_save { self.domain = domain.downcase }

  # validates - ensures attribute conforms to specified constraints
  # unique domain, required
  validates :domain, presence: true, uniqueness: true
  # email format, required
  validates :email, presence: true, email_format: { message: "invalid format for email" }
  # organisation name, required, must be of length between 2 and 120 characters
  validates :org_name, presence: true, length: { in: 2..120 }
  # site template, required, must be of value 1, 2 or 3
  validates :template, presence: true, inclusion: { in: 1..3 }

  # this allows us to save pages, account in the charity form
  # for nested resources
  accepts_nested_attributes_for :account, :pages

  # override to_param to show domain name instead of id
  # eg /charities/catactiontrust rather than /charities/1
  def to_param
    domain
  end
end
