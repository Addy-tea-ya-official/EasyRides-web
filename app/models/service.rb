class Service < ApplicationRecord
  #Associations
  belongs_to :user
  belongs_to :vehicle
end
