class ExportData::ToGoogleSheets::DailyForecasts < ExportData::ToGoogleSheets
  HEADERS = [
    'Date',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ]

  private

  def range
    'Forecast History!A1'
  end

  def array_of_arrays
    DailyForecast.rows
  end

  def headers
    HEADERS + [Time.now.utc.strftime('%m/%d/%Y')]
  end

  def spreadsheet_id
    KPIS_SPREADSHEET
  end
end
