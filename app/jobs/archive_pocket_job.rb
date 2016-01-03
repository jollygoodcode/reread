class ArchivePocketJob < ActiveJob::Base
  def perform(pocket)
    ArchivePocket.new(pocket).run
  end
end
