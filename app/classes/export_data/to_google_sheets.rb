class ExportData::ToGoogleSheets
  attr_reader :session, :worksheet, :spreadsheet
  SPREADSHEET = '1ZoJx5ZtwFu10v6dB5I57EesotO_UTkc5HutZShgOj_s'
  WORKSHEET = 'o5mnsi6'
  HEADERS = [
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
    set_rows
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
      save
    end

    def set_rows
      time_entry_rows = TimeEntry.rows
      puts "starting rows"
      time_entry_rows.each_with_index do |time_entry_attrs, row_num|
        puts "starting row #{row_num}"
        # start at row 2 (row 1 for headers)
        row_num = row_num + 2
        time_entry_attrs.each_with_index do |attr, column_num|
          puts "starting column #{column_num}"
          # start at column 1
          column_num = column_num + 1
          worksheet[row_num, column_num] = attr
        end
      end
    end

    def delete_rows
      worksheet.delete_rows(2, )
    end

    def set_timestamp
      worksheet[1, HEADERS.count + 1] = Time.now.in_time_zone(-5).strftime("%m/%d/%Y at %I:%M %p")
    end
end
