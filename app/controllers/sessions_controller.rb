class SessionsController < ApplicationController
  skip_before_action :authenticate!, only: %i[new create]
  before_action :set_session, only: %i[ destroy ]

  # GET /sessions
  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
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

  # DELETE /sessions/1
  def destroy
    @session.destroy!
    redirect_to sessions_url, notice: "That session has been logged out.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Current.user.sessions.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def session_params
      params.require(:session).permit(user: :screen_name)
    end
end
