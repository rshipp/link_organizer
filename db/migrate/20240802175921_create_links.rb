class CreateLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :links do |t|
      t.string :url
      t.string :source_url
      t.text :comment
      t.string :archive_url
      t.text :text
      t.datetime :published_at
      t.string :title
      t.text :notes

      t.timestamps
    end
    add_index :links, :url, unique: true
  end
end
