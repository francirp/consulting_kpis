require 'google/apis/sheets_v4'

module ExportData::GoogleSheetsWrapper
  attr_reader :sheets_service

  def initialize(args = {})
    @sheets_service = Google::Apis::SheetsV4::SheetsService.new
    session = GoogleDrive.saved_session("#{Rails.root}/app/classes/export_data/config.json")
    fetcher = session.instance_variable_get('@fetcher')
    authorization = fetcher.drive.request_options.authorization
    @sheets_service.authorization = authorization
    after_init(args)
  end
end