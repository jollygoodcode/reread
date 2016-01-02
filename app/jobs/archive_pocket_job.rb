class ArchivePocketJob < ActiveJob::Base
  def perform(pocket)
    service = ArchivePocket.new(pocket)
    service.run
  end
end
