class AddColumnsToTimeEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :time_entries, :billable_rate, :float
    add_column :time_entries, :cost_rate, :float
  end
end
