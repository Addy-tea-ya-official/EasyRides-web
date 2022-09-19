class VehiclesController < ApplicationController
  before_action :authenticate_user!
  def index
    user = get_user
    vehicles = Vehicle.where(user_id: user.id)
    vehicles_list = []
    vehicles.each do |vehicle|
      vehicles_list.push(
        {
          message: "Vehicle details",
          data:{
            vehicle_name: vehicle.name,
            registeration_number: vehicle.registeration_number
          }
        }
      )
    end
    render json: vehicles_list, status: 200   
  end

  def create_vehicle
    user = get_user
    vehicle = Vehicle.new(
      {
        name: vehicle_params[:vehicle_name],
        registeration_number: vehicle_params[:vehicle_registeration_number],
        capacity: vehicle_params[:vehicle_capacity],
        user_id: user.id
      }
    )
    if vehicle.save
      render json: {
        message: "Vehicle saved",
        data:{
          vehicle_registeration_number: vehicle.registeration_number
        }
      }, status: 200 
    else
      render json: {error: "Vehicle not saved"}, status: 422
    end
  end
  private
    def vehicle_params
      params.require(:vehicle).permit(:vehicle_name, :vehicle_registeration_number, :vehicle_capacity)
    end
end
