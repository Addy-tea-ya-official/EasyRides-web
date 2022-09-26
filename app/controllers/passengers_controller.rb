class PassengersController < ApplicationController
  before_action :authenticate_user!

  def index_tickets
    user = get_user
    passenger_tickets = ServiceTicket.select(:id, :driver_name, :vehicle_name, :vehicle_registeration_number, :boarding_time, :request_status).where(passenger_id: user.id).limit(10)
    if passenger_tickets.present?
      render json:{
        message: "Passenger Tickets",
        tickets: passenger_tickets
      }
    else
      return render json: {
        error: "User does not have any ticket"
      }, status: 204
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
        if(Service.find(user_recent_ticket.service_id).id.eql?(service.id))
          return render json:{
            message: "Appointment for this service already exists"
          }, status: 200
        end
      end
      ticket = ServiceTicket.new(
        {
          passenger_name: user.name,
          passenger_email: user.email,
          driver_id: Vehicle.find(Service.find(service.id).vehicle_id).user_id,
          boarding_time: service.boarding_time,
          driver_name: service.driver_name,
          vehicle_name: service.vehicle_name,
          vehicle_registeration_number: service.vehicle_registeration_number,
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
