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
    'Week'
  ]

  private

  def range
    'CY - Harvest Export!A1'
  end

  def array_of_arrays
    TimeEntry.rows
  end

  def headers
    HEADERS
  end

  def spreadsheet_id
    KPIS_SPREADSHEET
  end
end
