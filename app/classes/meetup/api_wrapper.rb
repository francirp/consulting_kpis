require 'httparty'

module Meetup
  module ApiWrapper
    BASE_URL = 'https://api.meetup.com'.freeze

    attr_reader :api_key

    def initialize(args = {})
      @api_key = args.fetch(:api_key, ENV['MEETUP_API_KEY'])
      after_init(args)
    end

    def get
      HTTParty.get(url, get_payload)
    end

    private

    def after_init(args)
      # optional hook for subclasses
    end

    def url
      "#{BASE_URL}#{endpoint}"
    end

    def get_payload
      {
        query: base_query.merge(query),
        headers: get_headers,
      }
    end

    def default_headers
      {}
    end

    def base_query
      { key: api_key }
    end

    def query
      {}
    end

    def endpoint
      raise "endpoint method is required by subclass: #{self.class.name}"
    end

    def get_headers
      default_headers
    end
  end
end