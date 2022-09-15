class Vehicle < ApplicationRecord
  #Associations
  has_many :services
  belongs_to :user

  #Validations
  validates :registeration_number, format: {with: /[A-Z][A-Z]\s\d\d\s[A-Z][A-Z]\s\d\d\d\d/, message:"Enter valid vehilce registeration number"} 
end
