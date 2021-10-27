class AddIsActiveToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :is_active, :boolean
    add_column :projects, :is_billable, :boolean
  end
end
