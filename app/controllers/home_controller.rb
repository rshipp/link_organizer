class HomeController < ApplicationController
  before_action :set_query

  ALLOWED_SEARCH_FIELDS = ['title', 'notes', 'comment', 'text']

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
    # Tokenize query.
    query = SearchTokenizer.tokenize(params[:query])

    # Restrict search_in to allowed fields.
    search_in = ALLOWED_SEARCH_FIELDS.intersection(params[:search_in])

    # Construct tag queries.
    @and_tags = Tag.where(id: params[:and_tags].split(','))
    @or_tags = Tag.where(id: params[:or_tags].split(','))
    @not_tags = Tag.where(id: params[:not_tags].split(','))

    and_tag_links = Link.where(id: @and_tags.map {|t| t.links.map {|l| l.id}}.reduce(&:intersection)&.uniq)
    or_tag_links = Link.where(id: @or_tags.map {|t| t.links}.flatten.map {|l| l.id}.uniq)
    not_tag_links = Link.where.not(id: @not_tags.map {|t| t.links}.flatten.map {|l| l.id}.uniq)

    # Do the actual field search.
    @links = Link.all
    if query.present? && search_in.present?
      @links = SearchConstructor.construct(Link, search_in, query)
    end

    # Then tie it all together.
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
