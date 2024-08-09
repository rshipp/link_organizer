class ImportLinkJob < ApplicationJob
  queue_as :default

  def perform(url, overwrite=false)
    service = ImportLink.new(url, overwrite)
    service.run
    Rails.logger.info("Sleeping...")
    sleep(5)
    Rails.logger.info("...slept")
  end
end
