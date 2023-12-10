module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate!
    helper_method :user_signed_in?
  end

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
end
