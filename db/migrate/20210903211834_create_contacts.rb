class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.integer :harvest_id, unique: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :send_surveys
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
    add_index :contacts, :harvest_id, unique: true
  end
end
