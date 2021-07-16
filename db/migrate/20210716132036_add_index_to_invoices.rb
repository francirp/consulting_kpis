class AddIndexToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_index :invoices, :harvest_id, unique: true
    remove_column :invoices, :last_payment_date
  end
end
