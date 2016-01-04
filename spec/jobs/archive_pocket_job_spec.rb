require 'rails_helper'

RSpec.describe ArchivePocketJob do
  describe '#perform' do
    let(:pocket)  { Pocket.new(raw: '') }
    let(:service) { double(:repocket) }

    it 'delegates to user' do
      expect(ArchivePocket).to receive(:new).with(pocket) { service }
      expect(service).to receive(:run)

      ArchivePocketJob.perform_now(pocket)
    end
  end
end
