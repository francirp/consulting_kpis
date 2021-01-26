class AddRevenueToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :revenue, :float
  end
end
