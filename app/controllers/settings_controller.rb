class SettingsController < ApplicationController
  before_filter :authenticate

  def show
    @settings = current_user.setting || current_user.create_setting
  end

  def update
    @settings = current_user.setting
    @settings.assign_attributes(model_params)

    # Only send email when email was blank previously (First time users)
    email_now = @settings.email_was.blank?

    if @settings.save
      RePocketJob.perform_later(current_user) if email_now

      redirect_to settings_path, notice: "We have updated your Settings. You'll receive an email from us soon!"
    else
      flash[:error] = 'Oops! Failed to update your Settings.'

      render :show
    end
  end

  private

    def model_params
      params.require(:setting).permit(:email, :time_zone, :send_at, :schedule, :number, :pause)
    end
end
