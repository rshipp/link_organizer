class QueuedLinksController < ApplicationController
  before_action :set_queued_link, only: %i[ show apply destroy ]

  def index
    @queued_links = QueuedLink.active
  end

  def show
  end

  def apply
    if @queued_link.data.present?
      Link.create!(
          url: @queued_link.url,
          **@queued_link.data
      )
    else
      ImportLinkJob.perform_later(@queued_link.url)
    end
    @queued_link.update!(applied_at: DateTime.now)

    respond_to do |format|
      format.html { redirect_to unprocessed_links_url, notice: "Link import started. It may take a few minutes for new links to appear." }
      format.json { render :show, status: :created, location: unprocessed_links_url }
    end
  end

  def destroy
    @queued_link.update!(deleted_at: DateTime.now)

    respond_to do |format|
      format.html { redirect_to queued_links_url, notice: "Link was successfully removed from queue." }
      format.json { head :no_content }
    end
  end

  private
    def set_queued_link
      @queued_link = QueuedLink.find(params[:id])
    end
end
