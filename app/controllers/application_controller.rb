class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  before_filter :configure_permitted_parameters, if: :devise_controller?
  helper_method :voted_for_reply, :count_vote_for_reply

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(:name, :email, :password, :current_password, :avatar)
    end
  end

  def ensure_signup_complete
    return if action_name == "finish_signup"
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  

  def voted_for_reply(user_id, reply_id)
    @votes = Vote.where(user_id: user_id, reply_id: reply_id).all
    @result = 0
    @votes.each do |vote|
      @result += vote.vote_action
    end
    @result
  end

  # def count_vote_for_reply(reply_id)
  #   @votes = Vote.where(reply_id: reply_id).all
  #   @result = 0
  #   @votes.each do |vote|
  #     @result += vote.vote_action
  #   end
  #   @result
  # end

end
