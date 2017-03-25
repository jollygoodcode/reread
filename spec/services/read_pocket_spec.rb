require 'rails_helper'

RSpec.describe ReadPocket do
  describe '#read!' do
    let(:user) { create(:user, api_key: 2) }

    let(:service) { ReadPocket.new(user, redirect_url) }

    context 'when url is nil, fixes https://github.com/jollygoodcode/reread-issues/issues/25' do
      let(:redirect_url) { nil }
      let!(:pocket)      { user.pockets.create!(raw: { item_id: '12345' }) }

      before { user.setting = create(:setting, redirect_to: :pocket_url, archive: false) }

      it 'fails gracefully' do
        expect {
          service.read!
        }. to_not raise_error
      end
    end

    context 'when user prefers to be redirected to Pocket' do
      let(:redirect_url) { 'https://getpocket.com/a/read/12345' }
      let!(:pocket)      { user.pockets.create!(raw: { item_id: '12345' }) }

      before { user.setting = create(:setting, redirect_to: :pocket_url, archive: false) }

      it 'marks read_at' do
        expect {
          service.read!
        }. to change { pocket.reload.read_at }.from(nil).to(anything)
      end

      context 'when user prefers to mark as archive' do
        before { user.setting.update(archive: true) }

        it 'delegates to ArchivePocketJob' do
          expect(ArchivePocketJob).to receive(:perform_later).with(pocket)

          service.read!
        end
      end

      context 'when user prefers not to mark as archive' do
        before { user.setting.update(archive: false) }

        it 'does not delegates to ArchivePocketJob' do
          expect(ArchivePocketJob).to_not receive(:perform_later).with(pocket)

          service.read!
        end
      end
    end

    context 'when user prefers to be redirected to given_url' do
      let(:redirect_url) { 'https://www.google.com' }
      let!(:pocket)      { user.pockets.create!(raw: { given_url: 'https://www.google.com' }) }

      before { user.setting = create(:setting, redirect_to: :given_url, archive: false) }

      it 'marks read_at' do
        expect {
          service.read!
        }. to change { pocket.reload.read_at }.from(nil).to(anything)
      end

      context 'when user prefers to mark as archive' do
        before { user.setting.update(archive: true) }

        it 'delegates to ArchivePocketJob' do
          expect(ArchivePocketJob).to receive(:perform_later).with(pocket)

          service.read!
        end
      end

      context 'when user prefers not to mark as archive' do
        before { user.setting.update(archive: false) }

        it 'does not delegates to ArchivePocketJob' do
          expect(ArchivePocketJob).to_not receive(:perform_later).with(pocket)

          service.read!
        end
      end
    end
  end
end
