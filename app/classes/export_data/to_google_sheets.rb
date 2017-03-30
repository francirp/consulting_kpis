class ExportData::ToGoogleSheets
  attr_reader :session, :worksheet, :spreadsheet
  SPREADSHEET = ENV['SPREADSHEET']
  WORKSHEET = ENV['WORKSHEET']
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

  def initialize(args = {})
  end

  def update
    @session = GoogleDrive.saved_session("#{Rails.root}/public/config.json")
    @spreadsheet = @session.spreadsheet_by_key(SPREADSHEET)
    @worksheet = @spreadsheet.worksheets.detect {|ws| ws.worksheet_feed_url.split("/").last == WORKSHEET }
    set_headers
    update_cells
    set_timestamp
    save
  end

  private

    def save 
      puts "saving worksheet"
      worksheet.save
    end

    def set_headers
      puts "starting headers"
      HEADERS.each_with_index do |header, index|
        worksheet[1, index + 1] = header
      end
    end

    def update_cells
      puts "starting rows"
      chunk = 50
      current = 0
      time_entry_rows = TimeEntry.rows
      time_entry_rows.each_slice(chunk) do |rows|
        worksheet.update_cells(2 + current, 1, rows)
        worksheet.save
        current += chunk
      end
    end    

    def set_timestamp
      worksheet[1, HEADERS.count + 1] = Time.now.in_time_zone(-5).strftime("%m/%d/%Y at %I:%M %p")
    end
end
