require 'open-uri'

module ChicagoTechEvents
  class PullEvents
    URL = 'http://chicagotechevents.com/'
    attr_reader :doc

    def initialize
      @doc = Nokogiri::HTML(open(URL))
    end

    def pull_events
      events_nodes = doc.css('.event')
      events = events_nodes.map do |event_node|
        pull_event(event_node)
      end
    end

    private

    def pull_event(event_node)
      name = event_node.css('.title a').first.content
      link = event_node.css('.link').first['href']

      full_start = Time.parse(event_node.css('time').first['datetime'])
      start_date = full_start.to_date
      start_time = full_start.strftime('%l %P')

      full_end = Time.parse(event_node.css('time').last['datetime'])
      duration = ((full_end - full_start) / 60.0 / 60.0).round(1)

      venue = event_node.css('.location [itemprop="name"]').first.content

      Event.new(
        name: name,
        date: start_date,
        time: start_time,
        duration: duration,
        link: link,
        venue: venue,
        source: 'Chicago Tech Events'
      )
    end
  end
end
