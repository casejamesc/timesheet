class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize_user
  before_action :update_history
  before_action :create_quick_reports

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

  def create_quick_reports
    # @report = Report.new(project_filter: 0, task_filter: 0, project_id: project_default.id, task_id: task_default(project_default).id, email: '' );
    # @this_weeks_report     = @report.attributes(date1: beginning_of_this_week, date2: end_of_this_week)
    # @last_weeks_report     = @report.attributes(date1: beginning_of_last_week, date2: end_of_last_week)
    # @last_two_weeks_report = @report.attributes(date1: beginning_of_last_week, date2: end_of_this_week)
    # @this_months_report    = @report.attributes(date1: Date.today.at_beginning_of_month, date2: Date.today.at_end_of_month)
    # @last_months_report    = @report.attributes(date1: beginning_of_last_month, date2: end_of_last_month)
  end

  def make_boolean(str)
    str == "0" ? false : true
  end
end
