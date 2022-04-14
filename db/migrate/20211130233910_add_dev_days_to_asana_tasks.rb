class AddDevDaysToAsanaTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :asana_tasks, :dev_days, :float
  end
end
