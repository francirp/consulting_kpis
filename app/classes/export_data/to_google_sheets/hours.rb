class ExportData::ToGoogleSheets::Hours < ExportData::ToGoogleSheets
  attr_reader :month

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

    def after_init(args)
      @month = args[:month]
    end

    def worksheet_key
      # ENV['WORKSHEET']
      WORKSHEETS_BY_MONTH[month]
    end

    def headers
      HEADERS
    end

    def array_of_arrays
      TimeEntry.rows
    end
end
