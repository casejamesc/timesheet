class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, except: [:retreive_tasks]

  # GET /retreive_tasks
  def retreive_tasks
    @selected_project_id = params[:selected_project_id]
    @selected_project = Project.find(@selected_project_id);
    @tasks = @selected_project.tasks
  end

  # GET /shifts
  # GET /shifts.json
  def index
    # pass var to js
    gon.date1 = @date1 = params[:date1].to_date
    gon.date2 = @date2 = params[:date2].to_date
    gon.filter = @filter = params[:filter]
    
    @shifts = @current_user.shifts.by_date_range(@date1, @date2)
    @new_shift = Shift.new

    if @filter == 'daily' || @filter == 'today'
      render 'daily' 
    end
  end

  # GET /shifts/1
  # GET /shifts/1.json
  def show
  end

  # GET /shifts/new
  def new
    @shift = Shift.new
  end

  # GET /shifts/1/edit
  def edit
  end

  # POST /shifts
  # POST /shifts.json
  def create
    @shift = Shift.new(shift_params)

    respond_to do |format|
      if @shift.save
        format.html { redirect_to session[:two_pages_ago], notice: 'Shift was successfully created.' }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shifts/1
  # PATCH/PUT /shifts/1.json
  def update
    respond_to do |format|
      if @shift.update(shift_params)
        format.html { redirect_to session[:two_pages_ago], notice: 'Shift was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shifts/1
  # DELETE /shifts/1.json
  def destroy
    @id = @shift.to_json(only: [:id])
    @shift.destroy
    respond_to do |format|
      format.html { redirect_to shifts_url }
      format.json { render json: @id }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shift_params
      params.require(:shift).permit(:clock_in, :clock_out, :date_in, :date_out, :user_id, :project_id, :task_id, :notes, :add_cost)
    end
end
