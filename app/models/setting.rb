class Setting < ActiveRecord::Base
  extend Enumerize

  with_options on: :update do
    validates_presence_of :email, :time_zone, :send_at, :schedule, :number
  end

  enumerize :send_at,
            in: %w(01:00 03:00 05:00 07:00 09:00 11:00 13:00 15:00 17:00 19:00 21:00 23:00)

  enumerize :schedule,
            in: %w(everyday monday tuesday wednesday thursday friday saturday sunday),
            default: :everyday

  def can_send_now?(current_time)
    match_hour_in_tz?(current_time) && match_schedule_in_tz?(current_time)
  end

  private

    def match_hour_in_tz?(current_time)
      current_time.in_time_zone(time_zone).strftime('%H:00') == send_at
    end

    def match_schedule_in_tz?(current_time)
      schedule == 'everyday' ||
        current_time.in_time_zone(time_zone).strftime('%A').casecmp(schedule) == 0
    end
end
