class Link < ApplicationRecord
  has_and_belongs_to_many :tags

  def topics
    tags.where(category: 'topic')
  end

  def source_types
    tags.where(category: 'source_type')
  end

  def topic_ids
    topics.map {|t| t.id}
  end

  def source_type_ids
    source_types.map {|t| t.id}
  end
end
