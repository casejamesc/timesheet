class UsersController < ApplicationController
  skip_before_action :authorize_user

  before_action :authorize_admin, except: [:create]
  before_action :set_user, only: [:edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:username)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html {
          if params[:from] === 'sign-up'
            session[:user_id] = @user.id
            redirect_to filtered_shifts_path('daily', Date.today, Date.today), notice: 'Thank you for joining Shiftkeeper!' 
          else
            redirect_to users_url, notice: @user.username + ' was successfully created.' 
          end
        }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { 
          if params[:from] = 'sign-up'
            render 'sessions/new'
          else
           render action: 'new'
          end
        }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: @user.username + ' was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation)
    end
end
