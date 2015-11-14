module RequestStubHelper
  def stub_pocket_get_request(token)
    stub_request(:get, "https://getpocket.com/v3/get?access_token=#{token}&consumer_key=#{ENV['POCKET_CONSUMER_KEY']}&detailType=complete")
      .to_return(:status => 200, :body => fake_pocket_get_request_body, :headers => {})
  end

  private

    def fake_pocket_get_request_body
      File.read(Rails.root.join('spec/fixtures/fake_pocket_get_request_body.json'))
    end
end
