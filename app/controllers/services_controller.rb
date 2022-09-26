class ServicesController < ApplicationController
  before_action :authenticate_user!

  def index
    services = Service.where.not(current_capacity: 0).where('services.boarding_time > ?', DateTime.now)
    services_list = []
    services.each do |service|
      services_list.push(
        {
          message: "Ride details",
          data:{
            driver: {
              name: service.driver_name
            },
            vehicle: { 
              name: service.vehicle_name
            },
            destination: service.destination,
            current_capacity: service.current_capacity,
            fair: service.fair,
            boarding_time: service.boarding_time,
            service_id: service.id
          }
        }
      )
    end 
    render json: services_list, status: 200
  end

  def new
    user = get_user
    render json:{
      message: "Driver details",
      data:{
        driver: {
          name: user.name
        },
        vehicles: Vehicle.select(:id, :registeration_number).where(user_id: user.id)
      }
    }, status: 200
  end

  def create
    user = get_user 
    vehicle = Vehicle.where(user_id: user.id).where(id: service_params[:vehicle_id]).last
    if vehicle.nil?
      render json: {error: "User does not have vehicle"}, status: 400
    else
      service = Service.new(
        {
          vehicle_name: vehicle.name,
          vehicle_registeration_number: vehicle.registeration_number,
          driver_name: vehicle.driver_name,
          vehicle_id: vehicle.id,
          destination: service_params[:destination],
          current_capacity: vehicle.capacity - 1,
          fair: service_params[:fair],
          boarding_time: service_params[:boarding_time]
        }
      )
      if service.save
        render json: {
          message: "Service created",
          data:{
            vehicle_id: service.vehicle_id, 
            destination: service.destination, 
            current_capacity: service.current_capacity, 
            fair: service.fair, 
            boarding_time: service.boarding_time.strftime('%Y-%m-%d %H:%M:%S')
          }
        }, status: 200 
      else
        render json: {
          error: "Service not created"
          }, status: :unprocessable_entity
      end
    end
  end

  private
    def service_params
      params.require(:service).permit(:vehicle_id, :destination, :fair, :boarding_time)
    end
end
