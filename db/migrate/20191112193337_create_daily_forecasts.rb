class CreateDailyForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :daily_forecasts do |t|
      t.jsonb :months
      t.date  :date

      t.timestamps null: false
    end
  end
end
