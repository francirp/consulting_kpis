class AddIsRetainerToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :is_retainer, :boolean
  end
end
