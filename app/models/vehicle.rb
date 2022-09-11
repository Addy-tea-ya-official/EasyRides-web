class Vehicle < ApplicationRecord
  #Associations
  has_one :driver_service
  belongs_to :user
end
