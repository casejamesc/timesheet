class SessionsController < ApplicationController
  skip_before_filter :authorize_user
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to filtered_shifts_sub_path('daily', 'today', Date.today, Date.today)
    else
      redirect_to root_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, alert: "Logged out"
  end

  def set_current_user

  end
end
