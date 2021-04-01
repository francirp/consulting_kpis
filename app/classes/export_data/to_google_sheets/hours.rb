class ExportData::ToGoogleSheets::Hours < ExportData::ToGoogleSheets
  HEADERS = [
    'Rows',
    'Date',
    'Client',
    'Project',
    'Hours',
    'Hours Rounded',
    'Billable?',
    'Invoiced?',
    'First Name',
    'Last Name',
    'Year',
    'Month',
    'Week',
    'Maintenance?',
    'Streamlined Checkout?',
    'Billable Rate',
  ]

  private

  def range
    'Harvest Hours!A1'
  end

  def array_of_arrays
    TimeEntry.rows
  end

  def headers
    HEADERS + [Time.now.utc.strftime('%m/%d/%Y')]
  end

  def spreadsheet_id
    KPIS_SPREADSHEET
  end
end
