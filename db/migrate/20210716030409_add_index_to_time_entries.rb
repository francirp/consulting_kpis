class AddIndexToTimeEntries < ActiveRecord::Migration[6.1]
  def change
    add_index :projects, :harvest_id, unique: true
    add_index :clients, :harvest_id, unique: true
    add_index :time_entries, :harvest_id, unique: true
  end
end
