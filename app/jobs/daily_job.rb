class DailyJob < ActiveJob::Base
  # DailyJob runs every hour.
  def perform
    current_time = Time.current.beginning_of_hour

    User.find_each do |user|
      RePocketJob.perform_later(user) if user.can_send_now?(current_time)
    end

  rescue => error
    PartyFoul::RacklessExceptionHandler.handle(error, {class: self.class.name, method: __method__, params: nil})
    raise error
  end
end
