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
  end
end
