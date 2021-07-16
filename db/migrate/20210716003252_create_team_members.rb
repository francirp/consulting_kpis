class CreateTeamMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :team_members do |t|
      t.string :first_name
      t.string :last_name
      t.integer :harvest_id
      t.boolean :is_contractor
      t.string :email
      t.boolean :is_active

      t.timestamps
    end
  end
end
