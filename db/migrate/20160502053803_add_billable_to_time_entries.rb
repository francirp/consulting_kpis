class AddBillableToTimeEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :time_entries, :billable, :boolean
  end
end
