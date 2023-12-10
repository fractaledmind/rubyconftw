class SessionsController < ApplicationController
  # ----- unauthenticated actions -----
  with_options only: %i[ new create ] do
    before_action :authenticate
  end

  # GET /sessions/new
  def new
    @session = Session.new
  end

  # POST /sessions
  def create
    @session = Session.new(
      user: User.find_or_initialize_by(screen_name: session_params.dig(:user, :screen_name)),
      user_agent: request.user_agent,
      ip_address: request.ip
    )


    if @session.save
      Current.session = @session
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }
      redirect_to root_url, notice: "You have been signed in.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  # ----- authenticated actions -----
  with_options only: %i[ destroy ] do
    before_action :authenticate!
  end

  # DELETE /sessions/1
  def destroy
    @session = Current.user.sessions.find(params[:id])
    @session.destroy!
    redirect_to sessions_url, notice: "That session has been logged out.", status: :see_other
  end

  private

    # Only allow a list of trusted parameters through.
    def session_params
      params.require(:session).permit(user: :screen_name)
    end
end
