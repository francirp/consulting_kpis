class AddShouldIgnoreToAsanaProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :asana_projects, :ignore, :boolean
  end
end
