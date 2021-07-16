class AddMoreColumnsToTimeEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :time_entries, :rounded_hours, :float
    add_column :time_entries, :harvest_client_id, :integer
    add_column :time_entries, :client_id, :bigint, foreign_key: true
  end
end
