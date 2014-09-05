class SessionsController < ApplicationController
  skip_before_filter :authorize_user

  def new
    # also the option to create new user on this page
    @user = User.new
  end

  def create
    user = User.find_by(username: params[:username])

    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.is_admin
        session[:is_admin] = true
        redirect_to users_path
      else
        redirect_to filtered_shifts_path('daily', Date.today, Date.today)
      end
    else
      redirect_to root_url, notice: "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out"
  end

  def catchall
    redirect_to root_url, notice: "Please log in"
  end
end
