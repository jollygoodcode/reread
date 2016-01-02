require "rails_helper"

RSpec.describe Pocket do
  context "associations" do
    it { is_expected.to belong_to :user }
  end
end
