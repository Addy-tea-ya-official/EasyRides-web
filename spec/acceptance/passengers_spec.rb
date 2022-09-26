require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Passengers" do
  let!(:passenger) {User.create!(email: "iop1@gmail.com", password: 123456, password_confirmation: 123456)}
  let!(:driver) {User.create!(email: "jkl1@gmail.com", password: 123456, password_confirmation: 123456)}
  let!(:vehicle) {Vehicle.create!(name: "a", registeration_number: "MH 12 KY 3212", capacity: 4, user_id: driver.id)}
  let!(:service) {Service.create!(vehicle_id: vehicle.id, destination: "K", current_capacity: 4, fair: 500, boarding_time: DateTime.now + 1)}
  let(:service_ticket) {ServiceTicket.create!({service_id: service.id, passenger_id: passenger.id, driver_id: driver.id, boarding_time: service.boarding_time})}
  
  get "/tickets" do
    context '200' do
      before do
        auth_headers = passenger.create_new_auth_token
        header "Authorization", auth_headers["Authorization"]
      end
      example "Listing passenger tickets" do
        expected_response = {
          message: "Passenger Tickets",
          tickets:[{
            id: service_ticket.id,
            request_status: service_ticket.request_status,
            driver_name: service_ticket.driver_name,
            vehicle_name: service_ticket.vehicle_name,
            vehicle_registeration_number: service_ticket.vehicle_registeration_number,
            boarding_time: service_ticket.boarding_time
          }]
        }.to_json
        do_request
        expect(status).to eq 200
        expect(response_body).to eq(expected_response)
      end
    end
  end

  post "/ticket" do
    parameter :id, "service id", required: true
    context '200' do
      before do 
        auth_headers = passenger.create_new_auth_token
        header "Authorization", auth_headers["Authorization"]
      end
      example "Passenger booking ride" do
        request = {
          service: {
            id: service.id
          }
        }
        expected_response = {
          message: "Ticket saved successfully",
          data:{
          service_id: service.id,
          passenger_id: passenger.id
          }
        }.to_json
        do_request(request)
        expect(status).to eq 200
        expect(response_body).to eq(expected_response)
      end
      context '200' do
        before do 
          auth_headers = passenger.create_new_auth_token
          header "Authorization", auth_headers["Authorization"]
          ServiceTicket.create!({service_id: service.id, passenger_id: passenger.id})
        end
        example "Passenger booking already booked ride" do
          request = {
            service: {
              id: service.id
            }
          }
          expected_response = {
            message: "Appointment for this service already exists",
          }.to_json
          do_request(request)
          expect(status).to eq 200
          expect(response_body).to eq(expected_response)
        end
      end
    end
  end

  get "/tickets" do
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
