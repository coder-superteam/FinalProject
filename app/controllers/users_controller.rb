class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
  end

  def update
    if @user.update(user_params)
      sign_in(@user == current_user ? @user : current_user, bypass: true)
      raise 'aaa'
      edirect_to @user, notice: "Your profile was successfully updated."
    else
      render "edit"
    end
  end

  def finish_signup
    if request.patch? && params[:user]
      if @user.update(user_params)
        sign_in(@user, bypass: true)
        redirect_to root_path, notice: "Your profile was successfully updated."
      else
        @show_errors = true
      end
    end
  end

  private
  def set_user
    @user = User.find params[:id]
  end

  def user_params
    accessibles = [ :name, :email ]
    accessibles << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessibles)
  end
end