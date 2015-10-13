class AddProjectReferencesToTimeEntries < ActiveRecord::Migration
  def change
    add_reference :time_entries, :project, index: true, foreign_key: true
  end
end
