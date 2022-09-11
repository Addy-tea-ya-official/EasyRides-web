class ServiceTicket < ApplicationRecord
  #Associations
  belongs_to :passenger, class_name: 'User'
  belongs_to :service
end
