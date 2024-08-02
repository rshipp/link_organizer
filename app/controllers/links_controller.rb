class LinksController < ApplicationController
  before_action :set_link, only: %i[ show edit update destroy ]

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
      link_tag_params[:tag_ids].split(',').each do |tag|
        if (Integer(tag) rescue false)
          if tag_record = Tag.find(tag)
            tags << tag_record
          else
            Rails.logger.error("Missing tag with id=#{tag}")
          end
        else
          new_tag = Tag.create(name: tag, category: 'topic')
          tags << new_tag
        end
      end
      @link.tags = tags
    end

    # Only allow a list of trusted parameters through.
    def link_params
      params.require(:link).permit(:url, :source_url, :comment, :archive_url, :text, :published_at, :title, :notes)
    end

    def link_tag_params
      params.require(:link).permit(:tag_ids)
    end
end
