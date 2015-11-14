require 'rails_helper'

RSpec.describe ApplicationController do
  describe '#authenticate' do
    controller do
      before_filter :authenticate
      def index
        head :ok
      end
    end

    def do_request
      get :index
    end

    context 'authenticated' do
      before { sign_in(create(:user)) }

      it 'is successful' do
        do_request

        expect(response).to be_successful
      end
    end

    context 'unauthenticated' do
      it 'is unsuccessful' do
        do_request

        expect(response).to_not be_successful
        expect(response).to redirect_to root_path
      end
    end
  end
end
