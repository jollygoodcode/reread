require 'rails_helper'

RSpec.describe RePocket do
  let(:user) do
    user = create(:user)
    user.create_setting
    user
  end

  describe '#retrieve' do
    let(:repocket) { RePocket.new(user) }

    context 'list is non-empty' do
      before do
        stub_pocket_get_request(user.token)
      end

      context 'retrieves based on setting number' do
        before { user.setting.update(number: 3) }

        it 'retrieves random Pockets' do
          expect {
            repocket.retrieve
          }.to change(Pocket, :count).by(3)

          expect(repocket.retrieve.count).to eq 3
        end
      end

      context 'retrieves unique Pocket' do
        before { user.setting.update(number: 1) }

        def new_pocket(user)
          service = RePocket.new(user)
          service.retrieve
        end

        it 'retrieves unique Pocket until exhausted' do
          pocket_1 = new_pocket(user)
          expect(Pocket.count).to eq 1

          pocket_2 = new_pocket(user)
          expect(pocket_1).to_not eq pocket_2
          expect(Pocket.count).to eq 2

          pocket_3 = new_pocket(user)
          expect(pocket_1).to_not eq pocket_3
          expect(pocket_2).to_not eq pocket_3
          expect(Pocket.count).to eq 3

          pocket_4 = new_pocket(user)
          expect(pocket_1).to_not eq pocket_4
          expect(pocket_2).to_not eq pocket_4
          expect(pocket_3).to_not eq pocket_4
          expect(Pocket.count).to eq 4

          pocket_5 = new_pocket(user)
          expect(pocket_1).to_not eq pocket_5
          expect(pocket_2).to_not eq pocket_5
          expect(pocket_3).to_not eq pocket_5
          expect(pocket_4).to_not eq pocket_5
          expect(Pocket.count).to eq 5

          pocket_exhausted = new_pocket(user)
          expect([pocket_1, pocket_2, pocket_3, pocket_4, pocket_5].flatten.map(&:id)).to include pocket_exhausted.map(&:id).first
          expect(Pocket.count).to eq 5
        end
      end
    end

    context 'list is empty' do
      before do
        stub_pocket_get_empty_request(user.token)
      end

      it 'returns [] array' do
        expect {
          repocket.retrieve
        }.not_to change(Pocket, :count)

        expect(repocket.retrieve).to be_blank
      end
    end
  end

  describe '#send_email' do
    let(:repocket) { RePocket.new(user) }

    context 'list is non-empty' do
      before do
        stub_pocket_get_request(user.token)
      end

      it 'sends email' do
        expect(DailyMail).to receive(:for) { double.as_null_object }

        repocket.send_email
      end
    end

    context 'list is empty' do
      before do
        stub_pocket_get_empty_request(user.token)
      end

      it 'sends email' do
        expect(DailyMail).not_to receive(:for)

        repocket.send_email
      end
    end
  end
end
