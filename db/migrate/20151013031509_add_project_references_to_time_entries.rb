class AddProjectReferencesToTimeEntries < ActiveRecord::Migration[6.1]
  def change
    add_reference :time_entries, :project, index: true, foreign_key: true
  end
end
