class CreateQueuedLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :queued_links do |t|
      t.string :url, null: false
      t.json :data
      t.references :user, null: false, foreign_key: true
      t.datetime :applied_at

      t.timestamps
    end
  end
end
