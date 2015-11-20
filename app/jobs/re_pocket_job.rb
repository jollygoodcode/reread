class RePocketJob < ActiveJob::Base
  def perform(user)
    repocket = RePocket.new(user)
    repocket.run
  end
end
