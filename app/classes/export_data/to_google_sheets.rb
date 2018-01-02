class ExportData::ToGoogleSheets
  include ExportData::GoogleSheetsWrapper
  KPIS_SPREADSHEET = '18OOxc6ihqQC3J8na6sJOwpXrJnfLmmPTD6NdNTGBGS0'.freeze
  EVENTS_SPREADSHEET = '16iENqAuXt1S5Z62c0km00PKgISPsbMHEkBWy0M8aWdQ'.freeze

  def after_init(args)
    # hook
  end

  def update
    value_range = Google::Apis::SheetsV4::ValueRange.new
    value_range.major_dimension = 'ROWS'
    value_range.range = range
    value_range.values = array_of_arrays
    value_range.values.unshift(headers)

    sheets_service.update_spreadsheet_value(
      spreadsheet_id,
      value_range.range,
      value_range,
      value_input_option: 'RAW'
    )
  end

  private

  def range
    raise 'range method is required'
  end

  def array_of_arrays
    raise 'array_of_arrays method is required'
  end

  def headers
    raise 'headers method is required'
  end

  def spreadsheet_id
    raise 'spreadsheet_id method is required'
  end
end
