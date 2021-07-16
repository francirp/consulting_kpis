class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.date :issue_date
      t.date :last_payment_date
      t.integer :harvest_id
      t.references :client, null: false, foreign_key: true
      t.float :amount
      t.date :period_start
      t.date :period_end
      t.string :state
      t.string :payment_term
      t.date :sent_at
      t.date :paid_date

      t.timestamps
    end
  end
end
