module ApplicationHelper
  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)

  def markdown(text)
    raw(@@markdown.render(text))
  end

  def source_type_icon(source_type_name)
    case source_type_name
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
    else
      ''
    end
  end
end
