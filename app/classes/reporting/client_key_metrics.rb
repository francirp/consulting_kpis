module Reporting
  class ClientKeyMetrics
    AVAILABLE_HOURS_PER_PERSON = 1572.0
    BASELINE_TARGET_HOURS_PER_PERSON = 1300.0

    attr_reader :filter, :client, :client_time_entries, :client_invoices, :team_member,
                :team_member_hours
    delegate :time_entries, :invoices, :start_date, :end_date, to: :filter

    def initialize(filter, client, opts = {})
      @filter = filter
      @client = client
      @client_time_entries = opts.fetch(:time_entries) { set_client_time_entries }
      @client_invoices = opts.fetch(:invoices) { set_client_invoices }
      @team_member = opts[:team_member] # for metrics about the team member's relationship to client
      @team_member_hours = opts[:team_member_hours]
    end

    def revenue
      @revenue ||= client_invoices.sum(&:amount)
    end

    def revenue_attributable_to_team_member
      revenue * team_member_percent
    end

    def effective_rate
      @effective_rate ||= revenue / hours_billed
    end

    def hours_billed
      @hours_billed ||= client_time_entries.sum(&:rounded_hours).round
    end

    def gross_cost
      @cost ||= client_time_entries.sum do |entry|
        entry.rounded_hours * entry.team_member.cost_per_hour
      end
    end

    def gross_profit
      @gross_profit ||= revenue - gross_cost
    end

    def gross_profit_percentage
      gross_profit / revenue
    end

    def net_cost
      gross_cost * Reporting::KeyMetrics::OVERHEAD_FACTOR
    end

    def net_profit
      revenue - net_cost
    end

    def net_profit_percentage
      net_profit / revenue
    end

    def team_member_hours_for_client
      return 0 unless team_member
      @team_member_hours_for_client ||= client_time_entries.sum do |t|
        next 0 unless t.team_member_id == team_member.id
        t.rounded_hours
      end
    end

    def team_member_percent
      return 0 unless team_member
      @team_member_percent ||= team_member_hours_for_client / hours_billed
    end

    def percent_of_team_members_hours
      return 0 unless team_member
      @percent_of_team_members_hours ||= team_member_hours_for_client / team_member_hours
    end

    private

    def set_client_time_entries
      time_entries.find_all { |t| t.client_id == client.id }
    end
    
    def set_client_invoices
      invoices.find_all { |i| i.client_id == client.id }
    end      
  end
end
