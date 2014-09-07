class ReportsController < ApplicationController
  # GET /shifts
  # POST /shifts

  respond_to :html, :js, :pdf

  def show    
  end

  def new  
    @report = Report.new
  end

  def create
    make_boolean('asdf')

    if Report::DEFAULTS.include? params[:name].to_s.to_sym
      @report = default_report params[:name]
    else 
      @report = Report.new(report_params)
    end

    @date1 = @report.date1.to_date
    @date2 = @report.date2.to_date
    @project = Project.find_by(id: @report.project_id)
    @task = Task.find_by(id: @report.task_id)

    @shifts = @current_user.shifts.by_date_range(@report.date1, @report.date2)
    if make_boolean @report.project_filter
      @shifts = @shifts.by_project(@project)
    elsif make_boolean @report.task_filter
      @shifts = @shifts.by_task(@task)
    end

    respond_to do |format|
      format.pdf do
        render pdf: 'report.pdf', template: 'reports/show.pdf.erb', layout: 'pdf_layout.html.erb', disposition: 'inline'
      end
      format.json do
        pdf = render_to_string pdf: 'report.pdf', template: 'reports/show.pdf.erb', layout: 'pdf_layout.html.erb'
        TimesheetMailer.email_report(pdf, @report.email).deliver
        render nothing: true
      end
      format.html do
        render 'show'
      end
    end
  end

  private
  
  def default_report(name)
    case name.to_s.to_sym
    when :this_week
      date1 = beginning_of_this_week
      date2 = end_of_this_week
    when :last_week
      date1 = beginning_of_last_week
      date2 = end_of_last_week
    when :last_two_weeks
      date1 = beginning_of_last_week
      date2 = end_of_this_week
    when :this_month
      date1 = Date.today.at_beginning_of_month
      date2 = Date.today.at_end_of_month
    when :last_month
      date1 = beginning_of_last_month
      date2 = end_of_last_month
    end
    Report.new(project_filter: 0, task_filter: 0, project_id: project_default.id, task_id: task_default(project_default).id, email: '', date1: date1, date2: date2)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def report_params
    params.require(:report).permit(:date1, :date2, :project_filter, :task_filter, :project_id, :task_id, :email)
  end
end
