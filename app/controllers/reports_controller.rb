class ReportsController < ApplicationController
  # GET /shifts
  # POST /shifts

  respond_to :html, :js, :pdf

  def show    
    
  end

  def new  
    
  end

  def create
    @date1 = params[:date1].to_date
    @date2 = params[:date2].to_date
    @shifts = @current_user.shifts.by_date_range(@date1, @date2)
    @projects = @current_user.projects

    respond_to do |format|
      format.pdf do
        pdf = render_to_string pdf: 'report.pdf', template: 'reports/show.pdf.erb', layout: 'pdf_layout.html.erb'
        TimesheetMailer.email_report(pdf).deliver
        render pdf: 'report.pdf', template: 'reports/show.pdf.erb', layout: 'pdf_layout.html.erb', disposition: 'inline'
      end
      format.html do
        render 'show'
      end
    end
  end


end
