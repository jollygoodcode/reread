class ReadPocketJob < ActiveJob::Base
  def perform(user, url)
    ReadPocket.new(user, url).run
  end
end
