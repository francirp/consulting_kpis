module Meetup
  class UpcomingEvents
    include ApiWrapper

    module TopicCategories
      BUSINESS = 2.freeze
      TECH = 34.freeze
    end

    module SelfGroups
      ONLY = 'only'.freeze
      INCLUDES = 'includes'.freeze
      # there is also an 'excludes' I think
    end

    EVENTS_PER = 500.freeze

    attr_reader :topic_category, :lat, :lon, :events_per

    def after_init(args = {})
      @self_groups = args.fetch(:self_groups, SelfGroups::ONLY)
      @topic_category = args.fetch(:topic_category, TopicCategories::TECH)
      @lat = args.fetch(:lat, ENV['LAT'])
      @lon = args.fetch(:lon, ENV['LON'])
      @events_per = args.fetch(:page, EVENTS_PER)
    end

    def endpoint
      '/find/upcoming_events'
    end

    def query
      {
        self_groups: 'only',
        topic_category: topic_category,
        lat: lat,
        lon: lon,
        page: events_per,
      }
    end

    def pull_events
      get['events'].map do |event_hash|
        pull_event(event_hash)
      end
    end

    def pull_event(event_hash)
      duration = event_hash['duration'] || 0.0
      duration = (duration / 1000.0 / 60.0 / 60.0).round(1)
      term = map_term(event_hash)
      local_time = convert_local_time(event_hash['local_time'])
      waitlisted = event_hash['waitlist_count'] > 0 ? 'Yes' : 'No'        

      Event.new(
        group: event_hash.dig('group', 'name'),
        name: event_hash['name'],
        date: event_hash['local_date'],
        time: local_time,
        duration: duration,
        waitlisted: waitlisted,
        link: event_hash['link'],
        venue: event_hash.dig('venue', 'name'),
        map_link: term.present? ? URI.escape("https://maps.google.com/?q=#{term}") : nil,
        source: 'Meetup'
      )
    end

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
    end\
  end
end
