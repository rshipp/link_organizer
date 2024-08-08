class HomeController < ApplicationController
  before_action :set_query

  def index
    if @query.present?
      @tags = Tag.where("name like ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%").order(:name)

      @links = Link.where("title like ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%")
        .or(Link.where("text like ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%"))
        .or(Link.where("comment like ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%"))
        .or(Link.where("notes like ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%"))
        .or(Link.where(id: @tags.map {|t| t.links}.flatten.map { |l| l.id }.uniq))
    end

    if turbo_frame_request?
      render partial: "search_results", locals: { links: @links, tags: @tags, query: @query }
    else
      render "index"
    end
  end

private

  def set_query
    @query = params[:query]
  end
end
