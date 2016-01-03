require 'rails_helper'

RSpec.describe ArchivePocket do
  include ActiveSupport::Testing::TimeHelpers

  describe '#archive' do
    let(:user)    { create(:user, api_key: 2) }
    let(:pocket)  { user.pockets.create!(raw: { 'item_id' => '12345' }) }

    let(:service) { ArchivePocket.new(pocket) }

    context 'success' do
      it 'is success' do
        travel_to 5.minutes.ago do
          stub_pocket_send_request(user.token, 12345, Time.current.to_i)

          expect(service.archive!).to be_truthy
        end
      end
    end

    context 'error' do
      it 'raises error' do
        travel_to 5.minutes.ago do
          stub_pocket_send_401_request(user.token, 12345, Time.current.to_i)

          expect { service.archive! }.to raise_error ArchivePocket::ARCHIVE_ERROR
        end
      end
    end
  end
end
