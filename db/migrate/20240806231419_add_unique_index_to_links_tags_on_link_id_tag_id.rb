class AddUniqueIndexToLinksTagsOnLinkIdTagId < ActiveRecord::Migration[7.1]
  def change
    add_index :links_tags, [:link_id, :tag_id], unique: true
  end
end
