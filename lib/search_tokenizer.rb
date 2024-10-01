class SearchTokenizer

  def self.tokenize(query)
    return query.scan(/(NOT |-)?(["'].+?["']|[^"\s]+)/)
      .map { |x| x.compact.join.gsub(/['"]/, '') }
  end
end
