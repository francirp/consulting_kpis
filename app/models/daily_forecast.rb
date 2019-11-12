class DailyForecast < ActiveRecord::Base
  scope :earliest, -> { order("date ASC") }
  def self.rows
    earliest.map do |forecast|
      display_date = forecast.date.strftime('%m/%d/%Y')
      [
        display_date,
        forecast.months['1'],
        forecast.months['2'],
        forecast.months['3'],
        forecast.months['4'],
        forecast.months['5'],
        forecast.months['6'],
        forecast.months['7'],
        forecast.months['8'],
        forecast.months['9'],
        forecast.months['10'],
        forecast.months['11'],
        forecast.months['12'],
      ]
    end
  end
end
