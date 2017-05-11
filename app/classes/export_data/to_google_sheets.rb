class ExportData::ToGoogleSheets
  attr_reader :session, :worksheet, :spreadsheet

  def initialize(args = {})
    @session = GoogleDrive.saved_session("#{Rails.root}/public/config.json")
    key = args.fetch(:spreadsheet_key, spreadsheet_key)
    @spreadsheet = @session.spreadsheet_by_key(key)
    @worksheet = @spreadsheet.worksheets.detect {|ws| ws.worksheet_feed_url.split("/").last == worksheet_key }
    after_init(args)
  end

  def update
    set_headers
    update_cells
    set_timestamp
    save
  end

  private

  def after_init(_args = {})
    # hook for subclasses
  end

  def spreadsheet_key
    ENV['SPREADSHEET']
  end

  # Interface methods
  def worksheet_key
    raise "worksheet_key method is required by #{self.class.name}"
  end

  def headers
    raise "headers method is required by #{self.class.name}"
  end

  def array_of_arrays
    raise "array_of_arrays method is required by #{self.class.name}"
  end
  # End Interface Methods

  def save 
    puts "saving worksheet"
    worksheet.save
  end

  def set_headers
    puts "starting headers"
    headers.each_with_index do |header, index|
      worksheet[1, index + 1] = header
    end
  end

  def update_cells
    puts "starting rows"
    chunk = 50
    current = 0
    array_of_arrays.each_slice(chunk) do |rows|
      worksheet.update_cells(2 + current, 1, rows)
      worksheet.save
      current += chunk
    end
  end

  def set_timestamp
    worksheet[1, headers.count + 1] = Time.now.in_time_zone(-5).strftime("%m/%d/%Y at %I:%M %p")
  end
end
