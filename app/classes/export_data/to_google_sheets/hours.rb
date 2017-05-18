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

    def worksheet_key
      ENV['WORKSHEET']
    end

    def headers
      HEADERS
    end

    def array_of_arrays
      TimeEntry.rows
    end
end
