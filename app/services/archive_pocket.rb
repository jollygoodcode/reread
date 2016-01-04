class ArchivePocket
  POCKET_URL    = 'https://getpocket.com/v3/send'.freeze
  ARCHIVE_ERROR = Class.new(Exception)

  def initialize(pocket)
    @user   = pocket.user
    @pocket = pocket
  end

  def run
    archive!
  end

  def archive!
    response = HTTP.get(url)

    if response.status == 200
      true
    else
      raise ARCHIVE_ERROR
    end
  end

  private

    attr_accessor :user, :pocket

    def url
      "#{POCKET_URL}?consumer_key=#{ENV["POCKET_CONSUMER_KEY_V#{user.api_key}"]}&access_token=#{user.token}&actions=#{actions}"
    end

    def actions
      [
        {
          action:  'archive',
          item_id: pocket.item_id,
          time:    Time.current.to_i
        }
      ].to_json
    end
end
