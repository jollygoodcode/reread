class Setting < ActiveRecord::Base
  extend Enumerize

  with_options on: :update do
    validates_presence_of :email, :time_zone, :send_at, :schedule, :number
  end

  enumerize :send_at,
            in: %w(00:00 01:00 02:00 03:00 04:00 05:00 06:00 07:00 08:00 09:00 10:00 11:00 12:00 13:00 14:00 15:00 16:00 17:00 18:00 19:00 20:00 21:00 22:00 23:00)

  enumerize :schedule,
            in: %w(everyday monday tuesday wednesday thursday friday saturday sunday),
            default: :everyday

  enumerize :number,
            in: %w(1 2 3 4 5 6 7 8 9 10)

  def can_send_now?(current_time)
    Rails.logger.info "[Setting] BEG----------"
    Rails.logger.info "[Setting] current_time: #{current_time}"
    Rails.logger.info "[Setting] current_time.in_time_zone(time_zone).strftime('%H:00'): #{current_time.in_time_zone(time_zone).strftime('%H:00')}"
    Rails.logger.info "[Setting] send_at: #{send_at}"
    Rails.logger.info "[Setting] current_time.in_time_zone(time_zone).strftime('%A'): #{current_time.in_time_zone(time_zone).strftime('%A')}"
    Rails.logger.info "[Setting] schedule: #{schedule}"
    Rails.logger.info "[Setting] END----------"

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
