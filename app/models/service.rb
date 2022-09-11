class Service < ApplicationRecord
  #Associations
  belongs_to :vehicle
  has_one :service_ticket
end
