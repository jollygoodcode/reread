class ReadPocketJob < ActiveJob::Base
  def perform(user, url)
    service = ReadPocket.new(user, url)
    service.run
  end
end


