module Reporting
  class ClientKeyMetrics
    AVAILABLE_HOURS_PER_PERSON = 1572.0
    BASELINE_TARGET_HOURS_PER_PERSON = 1300.0

    attr_reader :filter, :client, :client_time_entries, :client_invoices, :team_member,
                :team_member_hours, :client_tasks
    delegate :time_entries, :completed_tasks, :invoices, :start_date, :end_date, to: :filter

    def initialize(filter, client, opts = {})
      @filter = filter
      @client = client
      @client_time_entries = opts.fetch(:time_entries) { set_client_time_entries }
      @client_invoices = opts.fetch(:invoices) { set_client_invoices }
      @client_tasks = opts.fetch(:tasks) { set_client_tasks }
      @team_member = opts[:team_member] # for metrics about the team member's relationship to client
      @team_member_hours = opts[:team_member_hours]
    end

    def recent_average_team_pulse
      all_feedback_requests = FeedbackRequest.where(client: client, surveyable_type: "TeamMember").recent
      recent = all_feedback_requests.where("date >= ?", Date.current - 30.days)
      ratings = recent.pluck("rating AS r").compact
      return nil unless ratings.any?
      ratings.reduce(:+) / ratings.size.to_f # get the average
    end

    def recent_client_pulse
      all_feedback_requests = FeedbackRequest.where(client: client, surveyable_type: "Client").recent
      recent = all_feedback_requests.where("date >= ?", Date.current - 30.days)
      ratings = recent.pluck("rating AS r").compact
      return nil unless ratings.any?
      ratings.reduce(:+) / ratings.size.to_f # get the average
    end    

    def revenue
      @revenue ||= client_invoices.sum(&:amount)
    end

    def revenue_attributable_to_team_member
      revenue * team_member_percent
    end

    def effective_rate
      return nil unless hours_billed > 0
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

    def team_member_dev_days
      return 0 unless team_member
      @team_member_dev_days ||= client_tasks.sum do |t|
        next 0 unless t.team_member_id == team_member.id
        t.dev_days || 0.0
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

    def dev_days      
      client_tasks.map(&:dev_days).compact.sum.round(1)
    end

    def velocity
      return 0 unless hours_billed
      ((dev_days / hours_billed.to_f) * 100.0).round(1)
    end

    def team_member_velocity
      return 0 unless team_member_hours_for_client && team_member_hours_for_client > 0
      ((team_member_dev_days / team_member_hours_for_client.to_f) * 100.0).round(1)
    end

    private

    def set_client_time_entries
      time_entries.find_all { |t| t.client_id == client.id }
    end
    
    def set_client_invoices
      invoices.find_all { |i| i.client_id == client.id }
    end
    
    def set_client_tasks
      completed_tasks.where(client_id: client.id) # chartkick depends on an activerecord collection
    end 
  end
end
