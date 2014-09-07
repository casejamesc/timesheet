class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize_user
  before_action :update_history

  include ApplicationHelper

  private

  def authorize_user
    if User.find_by(id: session[:user_id])
      set_current_user
    else
      redirect_to root_url, notice: "Please log in"
    end
  end

  def authorize_admin
    authorize_user
    redirect_to root_url, notice: "Please log in" unless @current_user.is_admin 
  end

  def set_current_user
    @current_user = User.find(session[:user_id])
    @tasks = @current_user.tasks
    @projects = @current_user.projects
  end

  def update_history
    session[:two_pages_ago] = session[:last_page]
    session[:last_page] = session[:current_page]
    session[:current_page] = request.fullpath
  end

end
