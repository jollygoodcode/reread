class RePocketJob < ActiveJob::Base
  def perform(user)
    service = RePocket.new(user)
    service.run
  end
end
