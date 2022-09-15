require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Services" do
  let!(:driver) {User.create!(email: "abcd3@gmail.com", password: 123456, password_confirmation: 123456)}
  let!(:passenger) {User.create!(email: "efgh3@gmail.com", password: 123456, password_confirmation: 123456)}
  let!(:vehicle) {Vehicle.create!(name: "a", registeration_number: "MH 12 KY 3212", capacity: 4, user_id: driver.id)}
  let!(:service) {Service.create!(vehicle_id: vehicle.id, destination: "K", current_capacity: 4, fair: 500, boarding_time: DateTime.now + 100)}

  get "/services" do
    context '200' do
      before do
        auth_headers = driver.create_new_auth_token
        header "Authorization", auth_headers["Authorization"]
      end
      example "Listing posted services" do
        expected_response = [{
          message: "Available ride services",
          data:{
            driver: {
              name: driver.name
            },
            vehicle: { 
              name: vehicle.name
            },
            destination: service.destination,
            current_capacity: service.current_capacity,
            fair: service.fair,
            boarding_time: service.boarding_time,
            service_id: service.id
          }
        }].to_json
        do_request
        expect(status).to eq 200
        # expect(response_body).to eq(expected_response)
      end
    end
  end

  get "/services/:id" do
    context '200' do
      let(:id) { service.id }
      before do 
        auth_headers = passenger.create_new_auth_token
        header "Authorization", auth_headers["Authorization"]
      end
      example "Passenger Booking ride" do
        expected_response = {
          message: "Ticket saved successfully",
          data:{
          service_id: service.id,
          passenger_id: passenger.id
          }
        }.to_json
        do_request
        expect(status).to eq 200
        expect(response_body).to eq(expected_response)
      end
    end
  end

  get "/services/new" do
    context '200' do
      before do 
        auth_headers = driver.create_new_auth_token
        header "Authorization", auth_headers["Authorization"]
      end
      example "Driver posting new service" do
        expected_response = {
          message: "Driver details",
          data:{
            driver: {
              name: driver.name
            },
            vehicles: Vehicle.select(:id, :registeration_number).where(user_id: driver.id)
          }
        }.to_json
        do_request
        expect(status).to eq 200
        expect(response_body).to eq(expected_response)
      end
    end
  end

  post "/services" do
    parameter :vehicle_id, "Ride vehicle", required: true
    parameter :destination, "Ride destination"
    parameter :fair, "Ride fair"
    parameter :boarding_time, "Ride boarding time"
    context '200' do
      before do 
        auth_headers = driver.create_new_auth_token
        header "Authorization", auth_headers["Authorization"]
      end
      example "Driver creating service" do
        request = {
          service: {
            vehicle_id: vehicle.id,
            destination: service.destination,
            fair: service.fair,
            boarding_time: service.boarding_time
          }
        }
        expected_response = {
          message: "Service created",
          data:{
            vehicle_id: vehicle.id,
            destination: service.destination,
            current_capacity: vehicle.capacity - 1,
            fair: service.fair,
            boarding_time: service.boarding_time.strftime('%Y-%m-%d %H:%M:%S')
          }
        }.to_json
        do_request(request)
        expect(status).to eq 200
        expect(response_body).to eq(expected_response)
      end
    end
  end
end
