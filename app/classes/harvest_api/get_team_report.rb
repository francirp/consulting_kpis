module HarvestApi
  class GetTeamReport
    attr_reader :client

    def initialize
      @client = ApiWrapper.new
    end

    def call
      client.get('/v2/reports/time/team', query: { from: '20210701', to: '20210702' })  
    end
  end
end