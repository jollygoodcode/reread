require 'rails_helper'

RSpec.describe Setting do
  include ActiveSupport::Testing::TimeHelpers

  context 'validations' do
    it { is_expected.to validate_presence_of(:email).on(:update) }
    it { is_expected.to validate_presence_of(:time_zone).on(:update) }
    it { is_expected.to validate_presence_of(:send_at).on(:update) }
    it { is_expected.to validate_presence_of(:schedule).on(:update) }
    it { is_expected.to validate_presence_of(:number).on(:update) }
    it { is_expected.to validate_presence_of(:state).on(:update) }
    it { is_expected.to validate_presence_of(:age_months).on(:update) }
    it { is_expected.to validate_presence_of(:redirect_to).on(:update) }
    it { is_expected.to validate_presence_of(:archive).on(:update) }
  end

  describe '#can_send_now?' do
    let(:setting) { create(:setting, time_zone: 'Singapore', send_at: send_at, schedule: schedule)}

    context 'current day and time matches send_at and schedule' do
      let(:send_at) { '07:00' }

      context 'specific schedule' do
        let(:schedule) { 'wednesday' }

        before do
          # 18 Nov 2015 is a Wednesday
          travel_to Time.new('2015', '11', '18', '07', '35', '45', '+08:00')
        end

        it { expect(setting.can_send_now?(Time.current)).to be_truthy }
      end

      context 'everyday' do
        let(:schedule) { 'everyday' }

        before do
          # 20 Nov 2015 is a Friday
          travel_to Time.new('2015', '11', '20', '07', '35', '45', '+08:00')
        end

        it { expect(setting.can_send_now?(Time.current)).to be_truthy }
      end
    end

    context 'only current day matches' do
      let(:send_at)  { '07:00' }
      let(:schedule) { 'wednesday' }

      before do
        # 18 Nov 2015 is a Wednesday
        travel_to Time.new('2015', '11', '18', '09', '20', '30', '+08:00')
      end

      it { expect(setting.can_send_now?(Time.current)).to be_falsy }
    end

    context 'only current time matches' do
      let(:send_at)  { '07:00' }
      let(:schedule) { 'wednesday' }

      before do
        # 20 Nov 2015 is a Friday
        travel_to Time.new('2015', '11', '20', '07', '35', '45', '+08:00')
      end

      it { expect(setting.can_send_now?(Time.current)).to be_falsy }
    end
  end
end
