module Reporting
  class ClientKeyMetrics
    AVAILABLE_HOURS_PER_PERSON = 1572.0
    BASELINE_TARGET_HOURS_PER_PERSON = 1300.0

    attr_reader :filter, :client, :client_time_entries, :client_invoices
    delegate :time_entries, :invoices, :start_date, :end_date, to: :filter

    def initialize(filter, client, opts = {})
      @filter = filter
      @client = client
      @client_time_entries = opts.fetch(:time_entries, set_client_time_entries)
      @client_invoices = opts.fetch(:invoices, :set_client_invoices) || []
    end

    def revenue
      @revenue ||= client_invoices.sum(&:amount)
    end

    def effective_rate
      @effective_rate ||= revenue / hours_billed
    end

    def hours_billed
      @hours_billed ||= client_time_entries.sum(&:rounded_hours).round
    end

    def gross_cost
      @cost ||= client_time_entries.sum do |entry|
        binding.pry if entry.rounded_hours.nil? || entry.team_member.cost_per_hour.nil?
        entry.rounded_hours * entry.team_member.cost_per_hour
      end
    end

    def gross_profit
      @gross_profit ||= revenue - gross_cost
    end

    private

    def set_client_time_entries
      time_entries.where(client_id: client.id)
    end
    
    def set_client_invoices
      invoices.find_all { |i| i.client_id == client.id }
    end      
  end
end
