class QueuedLinksController < ApplicationController
  before_action :set_queued_link, only: %i[ show apply destroy ]

  def index
    @queued_links = QueuedLink.all
  end

  def show
  end

  def apply
  end

  def destroy
  end

  private
    def set_queued_link
      @queued_link = QueuedLink.find(params[:id])
    end

end
