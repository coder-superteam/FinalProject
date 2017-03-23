class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(:username, :email, :password, :current_password, :avatar)
    end
  end

  def ensure_signup_complete
    return if action_name == "finish_signup"
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end
end
