class Service < ApplicationRecord
  #Associations
  belongs_to :vehicle
  has_one :service_ticket

  #Validations
  validates :boarding_time, :fair, presence: true
end
