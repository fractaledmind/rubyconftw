class ApplicationController < ActionController::Base
  include ActionView::RecordIdentifier

  NotAuthorized = Class.new(ActionController::RoutingError)

  rescue_from ApplicationController::NotAuthorized, with: :user_not_authorized
  helper_method :user_signed_in?

  private

    def authenticate
      return true if Current.session

      if session = Session.find_by(id: cookies.signed[:session_token])
        Current.session = session
        return true
      end

      false
    end

    def authenticate!
      return true if authenticate

      redirect_to new_session_path
    end

    def user_signed_in?
      Current.user.present?
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action." if user_signed_in?

      redirect_to root_path
    end
end
