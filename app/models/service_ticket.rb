class ServiceTicket < ApplicationRecord
  #Associations
  belongs_to :user
  belongs_to :service
end
