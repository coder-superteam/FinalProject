class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]

  def ensure_signup_complete
    return if action_name == "finish_signup"
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end
end
