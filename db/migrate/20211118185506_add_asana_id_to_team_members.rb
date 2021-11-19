class AddAsanaIdToTeamMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :team_members, :asana_id, :string
    add_index :team_members, :asana_id, unique: true

    add_column :projects, :asana_id, :string
    add_index :projects, :asana_id, unique: true
  end
end
