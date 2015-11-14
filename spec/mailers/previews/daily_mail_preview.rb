class DailyMailPreview < ActionMailer::Preview
  def for
    DailyMail.for(user, pockets)
  end

  private

    def user
      @user ||=
        begin
          _user = User.create(username: 'naruto', token: '12345')
          _user.create_setting(number: 1)
          _user
        end
    end

    def pockets
      raw_pocket_items =
        JSON.parse(
          File.read(Rails.root.join('spec/fixtures/fake_pocket_get_request_body.json'))
        )['list'].values

      raw_pocket_items.map do |raw_pocket_item|
        user.pockets.create!(raw: raw_pocket_item)
      end
    end
end
