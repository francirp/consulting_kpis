class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.boolean :is_hourly
      t.float :hourly_rate
      t.float :salary
      t.float :bonus
      t.float :total_comp
      t.date :start_date
      t.date :end_date
      t.references :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
