class ReportsController < ApplicationController
  # GET /shifts
  # POST /shifts

  respond_to :html, :js, :pdf

  def show    
    
  end

  def new  
   
  end

  def create
    @action = params[:commit]

    @date1 = params[:date1].to_date
    @date2 = params[:date2].to_date
    @project_filter = params[:project_filter]
    @task_filter = params[:task_filter]
    @project = Project.find_by(id: params[:project_id])
    @task = Task.find_by(id: params[:task_id])

    @shifts = @current_user.shifts.by_date_range(@date1, @date2)
    if @project_filter
      @shifts = @shifts.by_project(@project)
    end
    if @task_filter
      @shifts = @shifts.by_task(@task)
    end

    respond_to do |format|
      format.pdf do
        render pdf: 'report.pdf', template: 'reports/show.pdf.erb', layout: 'pdf_layout.html.erb', disposition: 'inline'
      end
      format.json do
        pdf = render_to_string pdf: 'report.pdf', template: 'reports/show.pdf.erb', layout: 'pdf_layout.html.erb'
        TimesheetMailer.email_report(pdf).deliver
        render json: {}
      end
      format.html do
        render 'show'
      end
    end
  end


end
