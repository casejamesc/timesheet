class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /retreive_tasks
  def retreive_tasks
    @project_id = params[:project_id]
    @project = Project.find(@project_id);
    @tasks = @project.tasks

    @task_id = params[:task_id]
    @task_class = params[:task_class]
    @task_name = params[:task_name]

    render layout: false
  end

  # GET /tasks
  # GET /tasks.json
  def index
    @projects = @current_user.projects
    @tasks = @current_user.tasks
    @new_project = Project.new
    @new_task = Task.new

    render "projects/index"
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path, notice: @task.name + ' was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @id = @task.to_json(only: [:id])
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { render json: @id }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :status, :rate, :default, :user_id, :project_id)
    end
end
