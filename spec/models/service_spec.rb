require 'rails_helper'

RSpec.describe Service, type: :model do
  let!(:driver) {User.create!(email: "jkl1@gmail.com", password: 123456, password_confirmation: 123456)}
  let!(:vehicle) {Vehicle.create!(name: "a", registeration_number: "MH 12 KY 3212", capacity: 4, user_id: driver.id)}

  describe 'validations' do
    context 'when boarding_time is valid' do
      before do 
        @service = Service.create(vehicle_id: vehicle.id, destination: "Katraj", current_capacity: 4, fair: 500, boarding_time: DateTime.now + 100)
      end
      it 'should validate with no errors' do
        expect(@service.errors.full_messages).to be_empty
      end
    end
    context 'when boarding_time is past' do
      before do 
        @service = Service.create(vehicle_id: vehicle.id, destination: "Katraj", current_capacity: 4, fair: 500, boarding_time: DateTime.now - 10)
      end
      it 'should validate with invalid boarding_time error when time is in past' do
        expect(@service.errors.full_messages).to eq(["Boarding time can't be in past"])
      end
    end
    context 'when boarding_time is not passed' do
      before do 
        @service = Service.create(vehicle_id: vehicle.id, destination: "Katraj", current_capacity: 4, fair: 500)
      end
      it 'should validate with invalid boarding_time error when boarding time is not passed in request json' do
        expect(@service.errors.full_messages).to eq(["Boarding time can't be blank"])
      end
    end
    context 'when boarding_time is not passed' do
      before do 
        @service = Service.create(vehicle_id: vehicle.id, destination: "Katraj", current_capacity: 4, fair: 500, boarding_time: "")
      end
      it 'should validate with invalid boarding_time error when boarding time is blank' do
        expect(@service.errors.full_messages).to eq(["Boarding time can't be blank"])
      end
    end
    context 'when boarding_time is not passed' do
      before do 
        @service = Service.create(vehicle_id: vehicle.id, destination: "Katraj", current_capacity: 4, fair: 500, boarding_time: "abc")
      end
      it 'should validate with invalid boarding_time error when symantically wrong time is passed' do
        expect(@service.errors.full_messages).to eq(["Boarding time can't be blank"])
      end
    end
    context 'when fair is not present' do
      before do 
        @service = Service.create(vehicle_id: vehicle.id, destination: "Katraj", current_capacity: 4, boarding_time: DateTime.now + 100)
      end
      it 'should validate with errors for fair is not passed in request json' do
        expect(@service.errors.full_messages).to eq(["Fair can't be blank"])
      end
    end
    context 'when fair is negative' do
      before do 
        @service = Service.create(vehicle_id: vehicle.id, destination: "Katraj", current_capacity: 4, fair:-10, boarding_time: DateTime.now + 100)
      end
      it 'should validate with errors for fair being negative' do
        expect(@service.errors.full_messages).to eq(["Fair can't be negative"])
      end
    end
  end
end
