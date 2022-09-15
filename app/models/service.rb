class Service < ApplicationRecord
  #Associations
  belongs_to :vehicle
  has_many :service_tickets

  #Validations
  validates :boarding_time, :fair, presence: true
  validate :valid_boarding_time?

  private
  def valid_boarding_time?
    if boarding_time < DateTime.now
      self.errors.add :boarding_time, 'Boarding time can not be in past'
    end  
  end
end
