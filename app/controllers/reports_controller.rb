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
    @report = Report.new(report_params)
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
        TimesheetMailer.email_report(pdf).deliver
        render nothing: true
      end
      format.html do
        render 'show'
      end
    end
  end

  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def report_params
    params.require(:report).permit(:date1, :date2, :project_filter, :task_filter, :project_id, :task_id, :email)
  end
end
