class RePocket
  POCKET_URL = 'https://getpocket.com/v3/get'.freeze

  def initialize(user)
    @user = user
  end

  def run
    retrieve
    send_email
  end

  def retrieve
    return [] if response_count == 0

    @pocket_items ||=
      (1..user.number.to_i).map do |_|
        random_item = new_random_item

        if already_sent?(random_item)
          find_pocket_item(random_item)
        else
          user.pockets.create!(raw: random_item)
        end
      end
  end

  def send_email
    if response_count == 0
      Rails.logger.info "[RePocket] Response is empty. Skip sending!"
    else
      Rails.logger.info "[RePocket] Sending Email BEG..."
      DailyMail.for(user, retrieve).deliver_later
      Rails.logger.info "[RePocket] Sending Email END..."
    end
  end

  private

    attr_reader :user

    def url
      "#{POCKET_URL}?consumer_key=#{ENV['POCKET_CONSUMER_KEY']}&access_token=#{user.token}&detailType=complete"
    end

    def response
      @response ||= JSON.parse HTTP.get(url).body
    end

    def response_count
      response['list'].count
    end

    def response_random_index
      rand(response_count)
    end

    def response_random_item
      response['list'].values[response_random_index]
    end

    def new_random_item
      pocket_item = response_random_item
      find_count  = 0

      while already_sent?(pocket_item) && find_count <= max_refind
        pocket_item = response_random_item
        find_count += 1
      end

      pocket_item
    end

    def max_refind
      50
    end

    def find_pocket_item(pocket_item)
      user.pockets.find_by("raw -> 'item_id' ? '#{pocket_item['item_id']}'")
    end

    def already_sent?(pocket_item)
      find_pocket_item(pocket_item).present?
    end
end
