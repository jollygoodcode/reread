class ApplicationController < ActionController::Base
  protect_from_forgery with: :reset_session

  helper_method :current_user, :user_signed_in?

  private

    def authenticate
      unless user_signed_in?
        redirect_to root_path, alert: 'Oops. You will have to sign in to do that.'
      end
    end

    def user_signed_in?
      current_user.present?
    end

    def current_user
      @current_user ||= User.find_by(remember_token: session[:remember_token])
    end
end
