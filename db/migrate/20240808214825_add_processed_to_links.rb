class AddProcessedToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :processed, :boolean, default: false
  end
end
