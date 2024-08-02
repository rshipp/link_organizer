class ChangeLinkTagsToLinksTags < ActiveRecord::Migration[7.1]
  def change
    rename_table :link_tags, :links_tags
  end
end
