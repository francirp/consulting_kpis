module HarvestApi
  class GetContacts
    attr_reader :client, :page

    def initialize(opts = {})
      @client = ApiWrapper.new
      @page = opts.fetch(:page, 1)
    end

    def call
      res = client.get('/v2/contacts', query: { page: page })
    end
  end
end