class RePocketJob < ActiveJob::Base
  def perform(user)
    RePocket.new(user).run
  end
end
