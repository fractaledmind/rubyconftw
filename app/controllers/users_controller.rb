class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users/1
  # GET /user
  def show
  end

  # GET /users/new
  # GET /user/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  # GET /user/edit
  def edit
  end

  # POST /users
  # POST /user
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to user_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /user
  def update
    if @user.update(user_params)
      redirect_to user_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /user
  def destroy
    @user.destroy!
    redirect_to new_user_path, notice: "User was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = params.key?(:id) ? User.find(params[:id]) : Current.user
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:screen_name)
    end
end
