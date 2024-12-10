class AddDeletedAtToQueuedLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :queued_links, :deleted_at, :datetime
  end
end
