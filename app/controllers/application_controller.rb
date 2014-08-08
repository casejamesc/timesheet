class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_user

  def set_current_user
    @current_user = User.find(session[:user_id])
    @tasks = @current_user.tasks
    @projects = @current_user.projects
  end
end
