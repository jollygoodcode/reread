require 'rails_helper'

RSpec.describe SessionsController do
  describe "#create" do
    let(:username) { 'naruto' }
    let(:token)    { '123456' }

    before { request.env['omniauth.auth'] = { 'uid' => username, 'credentials' => { 'token' => token } } }

    def do_request
      post :create
    end

    context 'when user already exists' do
      let!(:user) { create(:user, username: username, token: token) }

      context "with same token" do
        it 'creates user and creates session' do
          expect { do_request }.not_to change(User, :count)

          expect(session[:remember_token]).to eq user.remember_token

          expect(response).to redirect_to settings_path
        end
      end

      context "with a new token" do
        let!(:user) { create(:user, username: username, token: "old-#{token}") }

        it "updates token" do
          expect { do_request }.not_to change(User, :count)

          expect(user.reload.token).to eq token
        end
      end
    end

    context 'when user does not exist' do
      it 'finds user and creates session' do
        expect { do_request }.to change(User, :count).by(1)

        user = User.last
        expect(session[:remember_token]).to eq user.remember_token

        expect(response).to redirect_to settings_path
      end
    end
  end

  describe "#destroy" do
    def do_request
      delete :destroy
    end

    before do
      session[:remember_token] = '12345'
      controller.instance_variable_set(:@current_user, double(:user))
    end

    it 'clears session and redirects to root' do
      do_request

      expect(session[:remember_token]).to be_blank
      expect(controller.instance_variable_get(:@current_user)).to be_blank

      expect(response).to redirect_to root_path
    end
  end
end
