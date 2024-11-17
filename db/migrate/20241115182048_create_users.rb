class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.boolean :admin

      t.index 'LOWER(email)', unique: true, name: 'index_users_on_lowercase_email' # <-- prevent duplicate emails

      t.timestamps
    end
  end
end
