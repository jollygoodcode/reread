# This is important.
# Otherwise all URLs will be appended with UTM
# and it will fail the finding of the Pocket item
# in EmailSubscriber
AhoyEmail.track utm_params: false

class EmailSubscriber
  def click(event)
    user = event[:message].user
    url  = event[:url]

    ReadPocketJob.perform_later(user, url)
  end
end

AhoyEmail.subscribers << EmailSubscriber.new
