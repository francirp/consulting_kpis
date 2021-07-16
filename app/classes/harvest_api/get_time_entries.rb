module HarvestApi
  class GetTimeEntries
    attr_reader :client, :start_date, :end_date, :page

    def initialize(start_date, end_date, opts = {})
      @client = ApiWrapper.new
      @start_date = start_date
      @end_date = end_date
      @page = opts.fetch(:page, 1)
    end

    def call
      from = start_date.strftime('%Y%m%d')
      to = end_date.strftime('%Y%m%d')
      res = client.get('/v2/time_entries', query: { from: start_date, to: end_date, page: page })
    end
  end
end