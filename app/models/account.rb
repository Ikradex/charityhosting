class Account < ActiveRecord::Base
  belongs_to :charity, foreign_key: :charity_id
end
