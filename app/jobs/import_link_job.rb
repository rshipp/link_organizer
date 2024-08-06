class ImportLinkJob < ApplicationJob
  queue_as :default

  def perform(url)
    service = ImportLink.new(url)
    service.run
    sleep(5)
  end
end
