require 'uri'

class ExportData::ToGoogleSheets::Events < ExportData::ToGoogleSheets
  HEADERS = [
    'Group',
    'Name',
    'Date',
    'Start',
    'Duration (hours)',
    'Waitlisted?',
    'Event URL',
    'Venue',
    'Location',
  ]

  private

  def range
    'Meetup.com!A1'
  end

  # rubocop:disable Metrics/MethodLength
  def array_of_arrays
    service = Meetup::UpcomingEvents.new
    service.get['events'].map do |event|
      duration = event['duration'] || 0.0
      duration = (duration / 1000.0 / 60.0 / 60.0).round(1)
      term = map_term(event)
      local_time = convert_local_time(event['local_time'])

      [
        event.dig('group', 'name'),
        event['name'],
        event['local_date'],
        local_time,
        duration,
        event['waitlist_count'] > 0 ? 'Yes' : 'No',
        event['link'],
        event.dig('venue', 'name'),
        term.present? ? URI.escape("https://maps.google.com/?q=#{term}") : ''
      ]
    end
  end
  # rubocop:enable Metrics/MethodLength

  def map_term(event)
    venue = event.dig('venue', 'name')
    address_1 = event.dig('venue', 'address_1')
    address_2 = event.dig('venue', 'address_2')
    city = event.dig('venue', 'city')
    state = event.dig('venue', 'state')
    [venue, address_1, address_2, city, state].compact.join(', ')
  end

  def convert_local_time(time_string)
    time = Time.parse(time_string)
    time.strftime('%l %P')
  end

  def headers
    HEADERS + [Time.now.utc.strftime('%m/%d/%Y')]
  end

  def spreadsheet_id
    EVENTS_SPREADSHEET
  end
end
