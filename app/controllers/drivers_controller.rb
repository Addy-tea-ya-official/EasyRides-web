class DriversController < ApplicationController
  before_action :authenticate_user!
  
  def index
    user = get_user
    requests = []
    vehicles = Vehicle.where(user_id: user.id)
    driver_requests = ServiceTicket.where(service_id: Service.where(vehicle_id: vehicles))
    driver_requests.each do |request|
      requests.push(
        {
          passenger_name: User.find(request.passenger_id).name,
          passenger_email: User.find(request.passenger_id).email,
          vehicle_registeration_number: Vehicle.find(Service.find(request.service_id).vehicle_id).registeration_number,
          request_status: request.request_status,
          request_id: request.id
        }
      )
    end
    render json: requests, status: 200 
  end

  def update_request_status
    user = get_user
    begin
      request = ServiceTicket.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {message: "Service Ticket not found"}, status: 400
    else
      service = Service.find(request.service_id)
      if(Vehicle.find(service.vehicle_id).user_id != user.id)
        render json: {message: "No requests found"}, status: 400
      else
        if get_request_status[:request_status]
          if(service.current_capacity > 0)
            service.current_capacity -= 1
            service.save!
            request.update!(get_request_status)
          end
        else
          request.update!(get_request_status)
        end
        render json: request, status: 200
      end
    end
  end

  private
    def get_request_status
      params.permit(:request_status)
    end
end
