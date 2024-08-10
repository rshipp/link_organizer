class AddRatingToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :rating, :integer
  end
end
