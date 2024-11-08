module ApplicationHelper
  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)

  def markdown(text)
    raw(@@markdown.render(text))
  end

  def source_type_icon(source_type_name)
    emoji = case source_type_name
    when "academic_article"
      '🎓'
    when "book"
      '📕'
    when "news_article"
      '📰'
    when "audio"
      '🎧'
    when "blog_post"
      '📝'
    when "social_post"
      '🗨'
    when "video"
      '🎥'
    when "graphic"
      '🖼'
    else
      ''
    end

    raw("<span aria-hidden='true'>#{emoji}</span>")
  end

  def url_domain(url)
    URI.parse(url).host.sub(/\Awww\./, '')
  end

  def site_name
    "#{Rails.application.config.site_topic} Links"
  end
end
