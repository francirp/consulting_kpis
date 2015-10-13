class AddRevenueToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :revenue, :float
  end
end
