module ApplicationHelper
  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)

  def markdown(text)
    raw(@@markdown.render(text))
  end
end
