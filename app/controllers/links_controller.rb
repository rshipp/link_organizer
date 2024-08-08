class LinksController < ApplicationController
  before_action :set_link, only: %i[ show edit update destroy run_import ]

  # GET /links or /links.json
  def index
    @links = Link.all
  end

  # GET /links/1 or /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/import
  def import_new
  end

  # POST /links/import
  def import_create
    links = params.require(:links).split

    links.each do |link|
      Rails.logger.debug("Enqueuing job with url=#{link}")
      ImportLinkJob.perform_later(link)
    end

    respond_to do |format|
      format.html { redirect_to links_url, notice: "Link import started. It may take a few minutes for new links to appear." }
      format.json { render :show, status: :created, location: links_url }
    end
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links or /links.json
  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        update_tags
        format.html { redirect_to link_url(@link), notice: "Link was successfully created." }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /links/1
  def run_import
    Rails.logger.debug("Enqueuing job with url=#{@link.url}, overwrite=true")
    # Force overwrite
    ImportLinkJob.perform_later(@link.url, true)

    respond_to do |format|
      format.html { redirect_to link_url(@link), notice: "Link import started. It may take a few minutes to update." }
      format.json { render :show, status: :created, location: link_url(@link) }
    end
  end

  # PATCH/PUT /links/1 or /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        update_tags
        format.html { redirect_to link_url(@link), notice: "Link was successfully updated." }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1 or /links/1.json
  def destroy
    @link.destroy!

    respond_to do |format|
      format.html { redirect_to links_url, notice: "Link was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    def update_tags
      tags = []

      # First, topic tags
      link_tag_params[:topic_ids].split(',').each do |tag_id|
        if (Integer(tag_id) rescue false)
          if tag = Tag.find(tag_id)
            tags << tag
          else
            Rails.logger.error("Missing topic tag with id=#{tag_id}")
          end
        else
          Rails.logger.info("Creating new tag=#{tag_id}")
          new_tag = Tag.create(name: tag_id, category: 'topic')
          tags << new_tag
        end
      end

      # Then, source_type tags
      link_tag_params[:source_type_ids].compact_blank.each do |tag_id|
        if tag = Tag.find(tag_id)
          tags << tag
        else
          Rails.logger.error("Missing source_type tag with id=#{tag_id}")
        end
      end

      # Then save.
      @link.tags = tags
    end

    # Only allow a list of trusted parameters through.
    def link_params
      params.require(:link).permit(:url, :source_url, :comment, :archive_url, :text, :published_at, :title, :notes)
    end

    def link_tag_params
      params.require(:link).permit(:topic_ids, source_type_ids: [])
    end
end
