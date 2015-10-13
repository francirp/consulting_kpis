class AddClientReferencesToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :client, index: true, foreign_key: true
  end
end
