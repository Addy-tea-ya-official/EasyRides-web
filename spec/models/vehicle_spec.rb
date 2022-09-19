require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  let!(:driver) {User.create!(email: "jkl1@gmail.com", password: 123456, password_confirmation: 123456)}

  describe 'validations' do
    context 'when registeration number is valid' do
      before do 
        @vehicle = Vehicle.create(name: "a", registeration_number: "MH 12 KY 3212", capacity: 4, user_id: driver.id)
      end
      it 'should validate with no errors' do
        expect(@vehicle.errors.full_messages).to be_empty
      end
    end
    context 'when registeration number is invalid' do
      before do 
        @vehicle = Vehicle.create(name: "a", registeration_number: "MH 3212", capacity: 4, user_id: driver.id)
      end
      it 'should validate with errors' do
        expect(@vehicle.errors.full_messages).to eq(["Registeration number is invalid"])
      end
    end
    context 'when registeration number is not passed' do
      before do 
        @vehicle = Vehicle.create(name: "a", capacity: 4, user_id: driver.id)
      end
      it 'should validate with errors' do
        expect(@vehicle.errors.full_messages).to eq(["Registeration number can't be blank", "Registeration number is invalid"])
      end
    end
    context 'when user is invalid' do
      before do 
        @vehicle = Vehicle.create(name: "a",  registeration_number: "MH 12 KY 3212", capacity: 4, user_id: 0)
      end
      it 'should validate with errors' do
        expect(@vehicle.errors.full_messages).to eq(["User must exist"])
      end
    end
    context 'when user is not passed' do
      before do 
        @vehicle = Vehicle.create(name: "a",  registeration_number: "MH 12 KY 3212", capacity: 4)
      end
      it 'should validate with errors' do
        expect(@vehicle.errors.full_messages).to eq(["User must exist"])
      end
    end
  end
end
