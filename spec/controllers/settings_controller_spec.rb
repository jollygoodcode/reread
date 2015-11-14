require 'rails_helper'

RSpec.describe SettingsController do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#show' do
    def do_request
      get :show
    end

    context 'when settings for current user already exists' do
      before { user.create_setting }

      it 'renders with existing setting' do
        expect { do_request }.to_not change(Setting, :count)

        expect(response).to render_template :show
      end
    end

    context 'when settings for current user does not exist' do
      it 'renders with new setting' do
        expect { do_request }.to change(Setting, :count).by(1)

        expect(response).to render_template :show
      end
    end
  end

  describe '#update' do
    def do_request
      patch :update, setting: params
    end

    context 'success' do
      let(:params) { attributes_for(:setting) }

      context 'update from empty setting' do
        before { user.create_setting } # empty setting

        it 'updates setting for current user, queues a job and redirects' do
          expect(RePocketJob).to receive(:perform_later).with(user)

          do_request

          setting = user.reload.setting
          params.each { |attr, val| expect(setting.send(attr)).to eq val }

          expect(response).to redirect_to settings_path
        end
      end

      context 'update from existing setting' do
        before { user.create_setting(attributes_for(:setting)) }

        it 'updates setting for current user and redirects' do
          expect(RePocketJob).to_not receive(:perform_later)

          do_request

          setting = user.reload.setting
          params.each { |attr, val| expect(setting.send(attr)).to eq val }

          expect(response).to redirect_to settings_path
        end
      end
    end

    context 'failure' do
      let(:params) { { email: '' } }

      before { user.create_setting } # empty setting

      it 'renders show' do
        expect(RePocketJob).to_not receive(:perform_later)

        do_request

        expect(response).to render_template :show
      end
    end
  end
end
