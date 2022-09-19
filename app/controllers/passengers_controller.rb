class PassengersController < ApplicationController
  before_action :authenticate_user!

  def index_tickets
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

  def create_ticket
    user = get_user
    begin
      service = Service.find(service_ticket_params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {error: "Service does not exist"}, status: 204
    else 
      user_recent_ticket = ServiceTicket.where(passenger_id: user.id, service_id: service.id).last
      if(!user_recent_ticket.nil?)
        if(Service.find(user_recent_ticket.service_id).boarding_time > DateTime.now)
          return render json:{
            message: "Appointment for this service already exists"
          }, status: 200
        end
      end
      ticket = ServiceTicket.new(
        {
          service_id: service.id,
          passenger_id: user.id
        }
      )
      if ticket.save
        render json: {
          message: "Ticket saved successfully",
          data: {
            service_id: ticket.service_id, 
            passenger_id: ticket.passenger_id
          }
        }, status: 200  
      else
        render json: {error: "Ride not booked"}, status: :unprocessable_entity
      end
    end
  end

  private
  def service_ticket_params
    params.require(:service).permit(:id)
  end
end
