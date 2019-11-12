class PullBudgetAmounts
  include ExportData::GoogleSheetsWrapper
  KPIS_SPREADSHEET_2020 = '1fhDJ871z0vpNK-UvzRfnxXD5SEvXc2yaSTMjgyLrbf8'.freeze
  KPIS_SPREADSHEET_2019 = '1uLUrGDuyNHr45PlCg19OEq551zGLQZo3SU73WToZMTA'.freeze

  def after_init(args = {})
  end

  def call
    result = sheets_service.batch_get_spreadsheet_values(
      KPIS_SPREADSHEET_2020,
      ranges: ranges,
      major_dimension: 'ROWS',
    )
    values = result.value_ranges.first.values.map(&:first).map do |value|
      value.scan(/(\d|[.-])/).join.try(:to_f)
    end
    DailyForecast.create(
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
        "12": values[12],
      }
    )
  end
  
  def ranges
    [
      'Budget!B1:B12',
    ]
  end
end