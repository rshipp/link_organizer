class Tag < ApplicationRecord
  has_and_belongs_to_many :links

  def humanized_name
    name.humanize
  end

  def to_s
    # called by combobox for some godawful reason
    to_combobox_display
  end

  def to_combobox_display
    name
  end

  # Class methods
  def self.top_topics
    Tag.top_tags(:topic, 10)
  end

  def self.top_source_types
    Tag.top_tags(:source_type, 7)
  end

  def self.top_tags(category, count)
    # Returns [[count, tag_name, tag_id]]
    Link.joins(:tags)
      .where(tags: {category: category})
      .group(:name, 'tags.id')
      .count.sort_by { |k, v| v }
      .last(count)
      .reverse
      .map do |tag_info, count|
        [count, tag_info[0], tag_info[1]]
      end
  end
end
