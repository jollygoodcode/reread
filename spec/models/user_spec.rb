require 'rails_helper'

RSpec.describe User do
  context 'associations' do
    it { is_expected.to have_one :setting }
    it { is_expected.to have_many :pockets }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :username }
    it { is_expected.to validate_presence_of :token }
  end

  describe '#generate_remember_token' do
    it 'generates from SecureRandom' do
      user = User.new
      expect(user.remember_token).to be_blank

      user.assign_attributes(username: 'naruto', token: '12345')
      user.save!

      expect(user.remember_token).to be_present
    end
  end
end
