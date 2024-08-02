class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :category

      t.timestamps
    end
    add_index :tags, :name, unique: true
  end
end
