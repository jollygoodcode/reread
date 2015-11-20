class DailyJob < ActiveJob::Base
  # DailyJob runs every hour.
  def perform
    current_time = Time.current.beginning_of_hour

    User.enabled.find_each do |user|
      if user.can_send_now?(current_time)
        Rails.logger.info "[DailyJob] Sending for User ID #{user.id}"
        RePocketJob.perform_later(user)
      end
    end
  end
end
