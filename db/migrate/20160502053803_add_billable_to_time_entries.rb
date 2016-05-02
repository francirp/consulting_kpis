class AddBillableToTimeEntries < ActiveRecord::Migration
  def change
    add_column :time_entries, :billable, :boolean
  end
end
