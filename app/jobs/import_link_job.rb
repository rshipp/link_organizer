class ImportLinkJob < ApplicationJob
  queue_as :default

  def perform(url, overwrite=false)
    service = ImportLink.new(url, overwrite)
    service.run
    sleep(5)
  end
end
