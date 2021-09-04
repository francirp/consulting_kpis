class CreateFeedbackRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :feedback_requests do |t|
      t.references :contact, null: false, foreign_key: true
      t.date :date
      t.integer :rating
      t.text :comment
      t.boolean :communication
      t.boolean :management
      t.boolean :team
      t.boolean :results
      t.boolean :timeline
      t.boolean :other

      t.timestamps
    end
    add_column :contacts, :last_feedback_request_date, :date
  end
end
