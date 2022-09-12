class ServicesController < ApplicationController
  before_action :authenticate_user!

  def index
    services = Service.where.not(current_capacity: 0)
    services_list = []
    services.each do |service|
      vehicle = Vehicle.find(service.vehicle_id)
      services_list.push(
        {
          driver: {
            name: User.find(vehicle.user_id).name
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
      )
    end 
    render json: services_list, status: 200
  end

  def book_ride
    user = get_user
    begin
      service = Service.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {message: "Service does not exist"}, status: 204
    else 
      ticket = ServiceTicket.new(
        {
          service_id: service.id,
          passenger_id: user.id
        }
      )
      if ticket.save
        render json: ticket, status: 200  
      else
        render json: {message: "Ride not booked"}, status: :unprocessable_entity
      end
    end
  end

  def new
    user = get_user
    render json:{
    driver: {
      name: user.name
    },
    vehicles: Vehicle.select(:id ,:registeration_number).where(user_id: user.id)
    }, status: 200
  end

  def create
    user = get_user 
    vehicle = Vehicle.where(user_id: user.id, id: service_params[:vehicle_id])
    if vehicle.empty?
      render json: {message: "User does not have vehicle"}, status: 400
    else
      service = Service.new(
        {
          vehicle_id: service_params[:vehicle_id],
          destination: service_params[:destination],
          current_capacity: vehicle[0].capacity - 1,
          fair: service_params[:fair],
          boarding_time: service_params[:boarding_time]
        }
      )
      if service.save
        render json: service, status: 200 
      else
        render json: {message: "Service not created"}, status: :unprocessable_entity
      end
    end
  end
  private
    def service_params
      params.require(:service).permit(:vehicle_id, :destination, :fair, :boarding_time)
    end
end
