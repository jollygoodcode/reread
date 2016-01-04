require 'rails_helper'

RSpec.describe RePocket do
  let(:user) do
    user = create(:user, api_key: 1)
    user.create_setting
    user
  end

  describe '#retrieve' do
    let(:service) { RePocket.new(user) }

    context 'list is non-empty' do
      context 'retrieves based on setting number' do
        before do
          stub_pocket_get_request(user.token)
          user.setting.update(number: 3)
        end

        it 'retrieves random Pockets' do
          expect {
            service.retrieve
          }.to change(Pocket, :count).by(3)

          expect(service.retrieve.count).to eq 3
        end
      end

      context 'retrieves based on state' do
        context 'retrieve from all' do
          before { user.setting.update(state: :all) }

          it 'retrieves with state=all' do
            expect(HTTP).to receive(:get).with(matching('state=all')) { double(:response, status: 200, body: fake_pocket_get_request_empty_body) }

            service.retrieve
          end
        end

        context 'retrieve from unread' do
          before { user.setting.update(state: :unread) }

          it 'retrieves with state=unread' do
            expect(HTTP).to receive(:get).with(matching('state=unread')) { double(:response, status: 200, body: fake_pocket_get_request_empty_body) }

            service.retrieve
          end
        end

        context 'retrieve from archive' do
          before { user.setting.update(state: :archive) }

          it 'retrieves with state=archive' do
            expect(HTTP).to receive(:get).with(matching('state=archive')) { double(:response, status: 200, body: fake_pocket_get_request_empty_body) }

            service.retrieve
          end
        end
      end

      context 'retrieves based on age' do
        include ActiveSupport::Testing::TimeHelpers

        before do
          # Stubbed response has 5 Pocket items,
          # each having a `time_added` that matches with the specs below
          stub_pocket_get_request(user.token)

          user.setting.update(number: 5)
        end

        context 'retrieve from 3 months ago' do
          before { user.setting.update(age_months: 3) }

          it 'retrieves article' do
            travel_to DateTime.parse("2015-12-31 23:59:59") do
              pockets = service.retrieve

              expect(pockets.map(&:item_id).uniq.count).to eq 4
              pockets.each do |pocket|
                expect(pocket.time_added).to be < 3.months.ago
              end
            end
          end
        end

        context 'retrieve from 6 months ago' do
          before { user.setting.update(age_months: 6) }

          it 'retrieves article' do
            travel_to DateTime.parse("2015-12-31 23:59:59") do
              pockets = service.retrieve

              expect(pockets.map(&:item_id).uniq.count).to eq 3
              pockets.each do |pocket|
                expect(pocket.time_added).to be < 6.months.ago
              end
            end
          end
        end

        context 'retrieve from 9 months ago' do
          before { user.setting.update(age_months: 9) }

          it 'retrieves article' do
            travel_to DateTime.parse("2015-12-31 23:59:59") do
              pockets = service.retrieve

              expect(pockets.map(&:item_id).uniq.count).to eq 2
              pockets.each do |pocket|
                expect(pocket.time_added).to be < 9.months.ago
              end
            end
          end
        end

        context 'retrieve from 12 months ago' do
          before { user.setting.update(age_months: 12) }

          it 'retrieves article' do
            travel_to DateTime.parse("2015-12-31 23:59:59") do
              pockets = service.retrieve

              expect(pockets.map(&:item_id).uniq.count).to eq 1
              pockets.each do |pocket|
                expect(pocket.time_added).to be < 12.months.ago
              end
            end
          end
        end
      end

      context 'retrieves unique Pocket' do
        before { stub_pocket_get_request(user.token) }

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
          service.retrieve
        }.not_to change(Pocket, :count)

        expect(service.retrieve).to be_blank
      end
    end

    context '401 unauthorized' do
      before do
        stub_pocket_get_401_request(user.token)
      end

      it 'fails gracefully' do
        expect {
          service.retrieve
        }.not_to change(Pocket, :count)

        expect(service.retrieve).to be_blank
      end

      it 'sets user to pause' do
        expect(user.pause).to be_falsey

        service.retrieve

        expect(user.pause).to be_truthy
      end
    end
  end

  describe '#send_email' do
    let(:service) { RePocket.new(user) }

    context 'list is non-empty' do
      before do
        stub_pocket_get_request(user.token)
      end

      it 'sends email' do
        expect(DailyMail).to receive(:for) { double.as_null_object }

        service.send_email
      end
    end

    context 'list is empty' do
      before do
        stub_pocket_get_empty_request(user.token)
      end

      it 'sends email' do
        expect(DailyMail).not_to receive(:for)

        service.send_email
      end
    end
  end
end
