require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Drivers" do
  let!(:passenger) {User.create!(email: "abcd3@gmail.com", password: 123456, password_confirmation: 123456)}
  let!(:driver) {User.create!(email: "efgh3@gmail.com", password: 123456, password_confirmation: 123456)}
  let!(:vehicle) {Vehicle.create!(name: "a", registeration_number: "MH 12 KY 3212", capacity: 4, user_id: driver.id)}
  let!(:service) {Service.create!(vehicle_id: vehicle.id, destination: "K", current_capacity: 4, fair: 500, boarding_time: DateTime.now + 100)}
  let!(:service_ticket) {ServiceTicket.create!({service_id: service.id, passenger_id: passenger.id, driver_id: driver.id, boarding_time: service.boarding_time})}

  patch "/requests/:id" do
    parameter :request_status, "Passenger ride request status"
    context '200' do
      let(:id) { service_ticket.id }
      before do 
        auth_headers = driver.create_new_auth_token
        # byebug
        header "Authorization", auth_headers["Authorization"]

      end
      example "Approving passenger request" do
        request = {
          request_status: true
        }
        expected_response = {
          message: "Updated request status",
          data:{
            request_status: true
          }
        }.to_json
        
        do_request(request) 
        expect(status).to eq 200
        response_body.should eq(expected_response)
      end
      example "Rejecting passenger request" do
        request = {
          request_status: false
        }
        expected_response = {
          message: "Updated request status",
          data:{
            request_status: false
          }
        }.to_json
        do_request(request) 
        expect(status).to eq 200
        response_body.should eq(expected_response)
      end
    end
    context '401' do
      let(:id) { service_ticket.id }
      before do 
        auth_headers = passenger.create_new_auth_token
        header "Authorization", auth_headers["Authorization"]
      end
      example "Passing invalid user as driver" do
        request = {
          request_status: true
        }
        do_request(request) 
        expect(status).to eq 401
        response_body.should eq('{"error":"Access forbidden"}')
      end
    end
    context '400' do
      let(:id) { 0 }
      before do 
        auth_headers = driver.create_new_auth_token
        header "Authorization", auth_headers["Authorization"]
      end
      example "Passing invalid service id to approve" do
        request = {
          request_status: true
        }
        do_request(request) 
        expect(status).to eq 400
        response_body.should eq('{"error":"Service Ticket not found"}')
      end
    end
  end

  get "/requests" do
    context '200' do
      before do
        auth_headers = driver.create_new_auth_token
        # byebug
        header "Authorization", auth_headers["Authorization"]
      end
      example "Listing passenger requests" do
        expected_response = {
          message: "Requests to driver",
          driver_requests: [{
            id: service_ticket.id,
            request_status: service_ticket.request_status,
            vehicle_name: service_ticket.vehicle_name,
            vehicle_registeration_number: service_ticket.vehicle_registeration_number,
            passenger_name: service_ticket.passenger_name,
            passenger_email: service_ticket.passenger_email,
            boarding_time: service_ticket.boarding_time
          }]
        }.to_json
        do_request
        expect(status).to eq 200
        expect(response_body).to eq(expected_response)
      end
    end
  end
end

