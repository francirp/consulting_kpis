class PullBudgetAmounts
  include ExportData::GoogleSheetsWrapper

  def after_init(args = {})
  end

  def call
    result = sheets_service.batch_get_spreadsheet_values(
      ExportData::ToGoogleSheets::KPIS_SPREADSHEET_2020,
      ranges: ranges,
      major_dimension: 'ROWS',
    )
    values = result.value_ranges.first.values.map(&:first).map do |value|
      value.scan(/(\d|[.-])/).join.try(:to_f)
    end
    daily_forecast = DailyForecast.find_or_initialize_by(date: Date.today)
    daily_forecast.attributes = {
      date: Date.today,
      months: {
        "1": values[0],
        "2": values[1],
        "3": values[2],
        "4": values[3],
        "5": values[4],
        "6": values[5],
        "7": values[6],
        "8": values[7],
        "9": values[8],
        "10": values[9],
        "11": values[10],
        "12": values[11],
      }
    }
    daily_forecast.save
  end
  
  def ranges
    [
      'Budget!B1:B12',
    ]
  end
end