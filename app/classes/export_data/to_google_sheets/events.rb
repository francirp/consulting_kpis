require 'uri'

class ExportData::ToGoogleSheets::Events < ExportData::ToGoogleSheets
  HEADERS = [
    'Source',
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
    'Event Data!B1'
  end

  # rubocop:disable Metrics/MethodLength
  def array_of_arrays
    meetup_events = Meetup::UpcomingEvents.new.pull_events
    chicago_tech_events = ChicagoTechEvents::PullEvents.new.pull_events
    events = meetup_events + chicago_tech_events
    events.map do |event|
      [
        event.source,
        event.group,
        event.name,
        event.date,
        event.time,
        event.duration,
        event.waitlisted,
        event.link,
        event.venue,
        event.map_link
      ]
    end
  end
  # rubocop:enable Metrics/MethodLength

  def headers
    HEADERS + [Time.now.utc.strftime('%m/%d/%Y')]
  end

  def spreadsheet_id
    EVENTS_SPREADSHEET
  end
end
