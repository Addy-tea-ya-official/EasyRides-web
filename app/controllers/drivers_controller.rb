class DriversController < ApplicationController
  before_action :authenticate_user!
  
  def index
    user = get_user
    requests = []
    request_available_offset_time = DateTime.now - 1
    driver_requests = ServiceTicket.select(:id ,:vehicle_name, :vehicle_registeration_number, :passenger_name, :passenger_email, :boarding_time, :request_status).where(driver_id: user.id).where('service_tickets.boarding_time > ?', request_available_offset_time)
    render json: {
      message: "Requests to driver",
      driver_requests: driver_requests
    }, status: 200 
  end

  def update_request_status
    user = get_user
    begin
      request = ServiceTicket.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {error: "Service Ticket not found"}, status: 400
    else
      service = Service.find(request.service_id)
      if(request.driver_id != user.id)
        render json: {error: "Access forbidden"}, status: 401
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
        render json: {
          message: "Updated request status",
          data:{
            request_status: request.request_status
          }
          }, status: 200
      end
    end
  end

  private
    def get_request_status
      params.permit(:request_status)
    end
end
