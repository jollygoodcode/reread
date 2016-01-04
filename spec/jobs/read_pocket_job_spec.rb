require 'rails_helper'

RSpec.describe ReadPocketJob do
  describe '#perform' do
    let(:user)    { build_stubbed(:user) }
    let(:url)     { 'https://www.google.com' }
    let(:service) { double(:repocket) }

    it 'delegates to user' do
      expect(ReadPocket).to receive(:new).with(user, url) { service }
      expect(service).to receive(:run)

      ReadPocketJob.perform_now(user, url)
    end
  end
end
