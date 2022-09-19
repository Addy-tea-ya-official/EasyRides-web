class Service < ApplicationRecord
  #Associations
  belongs_to :vehicle
  has_many :service_tickets

  #Validations
  validates :boarding_time, :fair, presence: true
  validate :valid_boarding_time
  validate :positive_fair_amount

  private
  def valid_boarding_time
    if boarding_time != nil
      if boarding_time < DateTime.now
        self.errors.add :boarding_time, "can't be in past"
      end  
    end
  end
  def positive_fair_amount
    if fair != nil
      if fair < 0
        self.errors.add :fair, "can't be negative"
      end  
    end
  end
end
