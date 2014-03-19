class Request < ActiveRecord::Base
  before_save { self.domain = domain.downcase }

  validate :uniqueness_in_charities

  # validates - ensures attribute conforms to specified constraints
  # unique domain, required
  validates :domain, presence: true

  # email format, required
  validates :email, presence: true, email_format: { message: "invalid format for email" },
    length: { minimum: 6, maximum: 320 }

  # organisation name, required, must be of length between 2 and 240 characters
  validates :org_name, presence: true, 
    length: { in: 2..240 }

  # site template, required, must be of value 1, 2 or 3
  validates :template, presence: true, 
    inclusion: { in: 1..3 },
    numericality: { only_integer: true }

  validates :approved, inclusion: { in: [ true, false ] }

  def uniqueness_in_charities
    # validates if the request does not have any unique attributes already in a charity already validated
    Charity.where( "email = ? OR domain = ? OR org_name = ?", self.email, self.domain, self.org_name ).blank?
  end
end
