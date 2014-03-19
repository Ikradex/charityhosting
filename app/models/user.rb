class User < ActiveRecord::Base
  has_many :charities
  has_many :posts

  # perform any value editing before save to DB
  before_save :validate_email

  validates :email, email_format: { message: "invalid format for email" },
    uniqueness: { case_sensitive: false },
    length: { minimum: 6, maximum: 254 },
    confirmation: true

  validates_presence_of :email, :password, :f_name, :l_name
  validates_length_of :f_name, :l_name, minimum: 2, maximum: 35
  validates_format_of :f_name, :l_name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/

  validates :password, length: { minimum: 6 }

  validates_associated :charities

  has_secure_password

  def validate_email
    email_parts = email.split( "@" )
    local = email_parts[ 0 ]
    domain = email_parts[ 1 ]

    if local.length >= 64 and domain.length >= 253
      errors.add( :email, "Maximum length of local and domain parts of an email is 64 and 253 respectively." )
    else 
      self.email = email.downcase
    end
  end

  def self.get_admin
    where( is_admin: 't' ).take
  end
end
