module RequestStubHelper
  def stub_pocket_get_request(token)
    stub_request(:get, "https://getpocket.com/v3/get?access_token=#{token}&consumer_key=#{ENV['POCKET_CONSUMER_KEY']}&detailType=complete")
      .to_return(:status => 200, :body => fake_pocket_get_request_body, :headers => {})
  end

  def stub_pocket_get_empty_request(token)
    stub_request(:get, "https://getpocket.com/v3/get?access_token=#{token}&consumer_key=#{ENV['POCKET_CONSUMER_KEY']}&detailType=complete")
      .to_return(:status => 200, :body => fake_pocket_get_request_empty_body, :headers => {})
  end

  def stub_pocket_get_401_request(token)
    stub_request(:get, "https://getpocket.com/v3/get?access_token=#{token}&consumer_key=#{ENV['POCKET_CONSUMER_KEY']}&detailType=complete")
      .to_return(:status => 401, :body => "401 Unauthorized", :headers => {})
  end

  def stub_pocket_send_request(token, item, time)
    stub_request(:get, "https://getpocket.com/v3/send?access_token=#{token}&consumer_key=#{ENV['POCKET_CONSUMER_KEY']}&actions=%5B%7B%22action%22:%22archive%22,%22item_id%22:#{item},%22time%22:#{time}%7D%5D").
      to_return(:status => 200, :body => "", :headers => {})
  end

  def stub_pocket_send_401_request(token, item, time)
    stub_request(:get, "https://getpocket.com/v3/send?access_token=#{token}&consumer_key=#{ENV['POCKET_CONSUMER_KEY']}&actions=%5B%7B%22action%22:%22archive%22,%22item_id%22:#{item},%22time%22:#{time}%7D%5D").
      to_return(:status => 401, :body => "", :headers => {})
  end

  private

    def fake_pocket_get_request_body
      File.read(Rails.root.join('spec/fixtures/fake_pocket_get_request_body.json'))
    end

    def fake_pocket_get_request_empty_body
      File.read(Rails.root.join('spec/fixtures/fake_pocket_get_request_empty_body.json'))
    end
end
