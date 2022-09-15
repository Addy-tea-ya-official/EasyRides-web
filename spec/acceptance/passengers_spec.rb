require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Passengers" do
  let!(:passenger) {User.create!(email: "iop1@gmail.com", password: 123456, password_confirmation: 123456)}
  let!(:driver) {User.create!(email: "jkl1@gmail.com", password: 123456, password_confirmation: 123456)}
  let!(:vehicle) {Vehicle.create!(name: "a", registeration_number: "MH 12 KY 3212", capacity: 4, user_id: driver.id)}
  let!(:service) {Service.create!(vehicle_id: vehicle.id, destination: "K", current_capacity: 4, fair: 500, boarding_time: DateTime.now + 100)}
  let!(:service_ticket) {ServiceTicket.create!({service_id: service.id, passenger_id: passenger.id})}
  # byebug
  get "/ticket" do
    context '200' do
      before do
        auth_headers = passenger.create_new_auth_token
        header "Authorization", auth_headers["Authorization"]
      end
      example "Listing passenger tickets" do
        expected_response = {
          message: "Passenger ticket details",
          data:{
            passenger_name: passenger.name,
            vehicle_name: vehicle.name,
            vehicle_registeration_number: vehicle.registeration_number,
            driver_name: driver.name,
            ticket_status: service_ticket.request_status
          }
        }.to_json
        do_request
        expect(status).to eq 200
        expect(response_body).to eq(expected_response)
      end
    end
  end

  get "/ticket" do
    context '204' do
      before do
        ServiceTicket.destroy_all
        auth_headers = passenger.create_new_auth_token
        header "Authorization", auth_headers["Authorization"]
      end
      example "Listing passenger tickets with passenger having no ticket" do
        do_request
        expect(status).to eq 204
      end
    end
  end
end
