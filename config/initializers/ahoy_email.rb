# This is important.
# Otherwise all URLs will be appended with UTM
# and it will fail the finding of the Pocket item
# in EmailSubscriber
AhoyEmail.track utm_params: false

class EmailSubscriber
  def click(event)
    user = event[:message].user
    url  = event[:url]

    pocket = user.pockets.find_by("raw -> 'item_id' ? '#{get_item_id(url)}'")
    pocket.update(read_at: Time.current) if pocket
  end

  private

    def get_item_id(url)
      url.gsub('https://getpocket.com/a/read/', '')
    end
end

AhoyEmail.subscribers << EmailSubscriber.new
