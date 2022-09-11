class Vehicle < ApplicationRecord
  #Associations
  has_one :service
  belongs_to :user
end
