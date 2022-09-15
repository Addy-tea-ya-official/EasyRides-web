class PassengersController < ApplicationController
  before_action :authenticate_user!

  def index
    user = get_user
    passenger_ticket = ServiceTicket.where(passenger_id: user.id)
    if passenger_ticket.empty?
      render json: {error: "User does not have any ticket"}, status: 204
    else
      passenger_ticket.each do |ticket|
        vehicle = Vehicle.find(Service.find(ticket.service_id).vehicle_id)
        render json: {
          message: "Passenger ticket details",
          data: {
            passenger_name: user.name,
            vehicle_name: vehicle.name,
            vehicle_registeration_number: vehicle.registeration_number,
            driver_name: User.find(vehicle.user_id).name,
            ticket_status: ticket.request_status
          }
        }, status: 200
      end
    end
  end
end
