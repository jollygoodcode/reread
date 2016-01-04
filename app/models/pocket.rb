class Pocket < ActiveRecord::Base
  belongs_to :user

  def item_id
    raw['item_id'].to_i
  end

  def time_added
    Time.at raw['time_added'].to_i
  end
end
