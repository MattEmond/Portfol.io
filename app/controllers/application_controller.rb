class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

    protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username, :age, :country, :occupation, :annual_income])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username, :age, :country, :occupation, :annual_income])

  end

  def after_sign_in_path_for (resource)
    stocks_path
  end

end
