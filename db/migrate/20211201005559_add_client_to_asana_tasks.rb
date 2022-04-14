class AddClientToAsanaTasks < ActiveRecord::Migration[6.1]
  def change
    add_reference :asana_projects, :client, foreign_key: true
    add_reference :asana_tasks, :client, foreign_key: true
  end
end
