class UsersController < ApplicationController
  # ----- unauthenticated actions -----
  with_options only: %i[ show new create ] do
    before_action :authenticate
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to user_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # ----- authenticated actions -----
  with_options only: %i[ edit update destroy ] do
    before_action :authenticate!
    before_action :set_current_user
  end

  # GET /user/edit
  def edit
  end

  # PATCH/PUT /user
  def update
    if @user.update(user_params)
      redirect_to user_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user
  def destroy
    @user.destroy!
    redirect_to new_user_path, notice: "User was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_current_user
      @user = Current.user
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:screen_name)
    end
end
