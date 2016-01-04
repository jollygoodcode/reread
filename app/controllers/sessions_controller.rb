class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    user = User.find_or_create_with(oauth_info)
    upgrade_api_key_for(user)
    create_session_for(user)

    redirect_to settings_path
  end

  def destroy
    destroy_session

    redirect_to root_path
  end

  private

  def oauth_info
    {
      username: request.env['omniauth.auth']['uid'],
      token: request.env['omniauth.auth']['credentials']['token']
    }
  end

  # When user logins now, they will be using the new API key which contains `Read` and `Modify` permission.
  # Hence, Upgrades user to use the new API key.
  def upgrade_api_key_for(user)
    user.update(api_key: 2)
  end

  def create_session_for(user)
    session[:remember_token] = user.remember_token
  end

  def destroy_session
    session[:remember_token] = nil
    @current_user = nil
  end
end
