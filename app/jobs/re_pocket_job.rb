class RePocketJob < ActiveJob::Base
  def perform(user)
    repocket = RePocket.new(user)
    repocket.run
  rescue => error
    PartyFoul::RacklessExceptionHandler.handle(error, {class: self.class.name, method: __method__, params: user.inspect})
    raise error
  end
end
