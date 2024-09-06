class HomeController < ApplicationController
  before_action :set_query

  def index
    if @query.present?
      @tags = Tag.where("name like ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%").order(:name)

      @links = Link.where("title like ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%")
        .or(Link.where("comment like ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%"))
        .or(Link.where("notes like ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%"))
        # Disabled for now, until the text is cleaned up.
        #.or(Link.where("text like ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%"))
        .or(Link.where(id: @tags.map {|t| t.links}.flatten.map { |l| l.id }.uniq))
    end

    if turbo_frame_request?
      render partial: "dynamic_homepage", locals: { links: @links, tags: @tags, query: @query }
    else
      render "index"
    end
  end

  def advanced_search
  end

  def advanced_search_results
    # TODO: Tokenize query
    query = params[:query].split

    @and_tags = Tag.where(id: params[:and_tags].split(','))
    @or_tags = Tag.where(id: params[:or_tags].split(','))
    @not_tags = Tag.where(id: params[:not_tags].split(','))

    and_tag_links = Link.where(id: @and_tags.map {|t| t.links.map {|l| l.id}}.reduce(&:intersection)&.uniq)
    or_tag_links = Link.where(id: @or_tags.map {|t| t.links}.flatten.map {|l| l.id}.uniq)
    not_tag_links = Link.where.not(id: @not_tags.map {|t| t.links}.flatten.map {|l| l.id}.uniq)

    # Then tie it all together.
    @links = Link.all
    if params[:query].present?
      # TODO: Real search
      query = query.join(' ')
      @links = @links.where("title like ?", "%#{ActiveRecord::Base.sanitize_sql_like(query)}%")
        .or(Link.where("comment like ?", "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"))
        .or(Link.where("notes like ?", "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"))
    end

    if @and_tags.present?
      @links = @links.and(and_tag_links)
    end

    if @or_tags.present?
      @links = @links.and(or_tag_links)
    end

    if @not_tags.present?
      @links = @links.and(not_tag_links)
    end
  end

private

  def set_query
    @query = params[:query]
  end
end
