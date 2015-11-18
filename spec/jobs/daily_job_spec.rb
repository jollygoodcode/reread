require 'rails_helper'

RSpec.describe DailyJob do
  context 'only for enabled users' do
    let!(:user_1) do
      _user = create(:user)
      _user.create_setting(pause: false)
      _user
    end

    let!(:user_2) do
      _user = create(:user)
      _user.create_setting(pause: true)
      _user
    end

    it 'only sends to enabled users' do
      expect_any_instance_of(User).to receive(:can_send_now?).once

      DailyJob.perform_now
    end
  end
end
