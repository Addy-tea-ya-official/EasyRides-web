class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  def get_user
    if user_signed_in?
      return current_user
    end
  end

  protected
  def configure_permitted_parameters
    Rails.logger.info "in ApplicationController.rb configure_permitted_parameters!"
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
