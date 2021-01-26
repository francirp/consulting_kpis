class AddClientReferencesToProjects < ActiveRecord::Migration[6.1]
  def change
    add_reference :projects, :client, index: true, foreign_key: true
  end
end
