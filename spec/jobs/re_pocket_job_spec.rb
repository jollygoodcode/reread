require 'rails_helper'

RSpec.describe RePocketJob do
  describe '#perform' do
    let(:user)    { build_stubbed(:user) }
    let(:service) { double(:repocket) }

    it 'delegates to user' do
      expect(RePocket).to receive(:new).with(user) { service }
      expect(service).to receive(:run)

      RePocketJob.perform_now(user)
    end
  end
end
