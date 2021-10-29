module Reporting
  class EmployeeKeyMetrics
    AVAILABLE_HOURS_PER_PERSON = 1572.0
    BASELINE_TARGET_HOURS_PER_PERSON = 1300.0

    attr_reader :filter, :employee, :employee_time_entries
    delegate :time_entries, :start_date, :end_date, :invoices_by_client_id,
             :time_entries_by_client_id, :invoices, to: :filter

    def initialize(filter, employee, opts = {})
      @filter = filter
      @employee = employee
      @employee_time_entries = opts.fetch(:time_entries) { set_employee_time_entries }
    end

    def available_hours
      days = filter.days_in_period_for_team_member(employee)
      potential_hours_per_day = AVAILABLE_HOURS_PER_PERSON/365.0
      days * potential_hours_per_day
    end

    # because we provide time for non-billable activities like SPACE
    def baseline_nonbillable_ratio
      BASELINE_TARGET_HOURS_PER_PERSON / AVAILABLE_HOURS_PER_PERSON
    end
    
    def net_available_hours
      employee.billable_target_ratio * available_hours.to_f
    end

    def target_hours
      employee.billable_target_ratio * available_hours.to_f * baseline_nonbillable_ratio
    end

    def hours_billed
      employee_time_entries.sum(&:rounded_hours).round(2)
    end

    def variance
      hours_billed - target_hours
    end

    def utilization
      (hours_billed / available_hours) * 100
    end

    def not_active?
      available_hours <= 0
    end

    def clients
      ids = employee_time_entries.distinct.pluck(:client_id)
      employee.clients.where(id: ids)
    end

    def metrics_by_client
      @clients_metrics ||= begin
        array = clients.map do |client|
          client_time_entries = time_entries.where(client_id: client.id)
          client_invoices = invoices.where(client_id: client.id)
          ClientKeyMetrics.new(
            filter,
            client,
            time_entries: client_time_entries,
            invoices: client_invoices,
            team_member: employee,
            team_member_hours: hours_billed,
          )
        end
        array.reject! { |c| c.team_member_percent < 0.05 }
        array.sort_by { |c| c.percent_of_team_members_hours }.reverse
      end
    end

    def clients_gross_cost
      metrics_by_client.map(&:gross_cost).sum
    end

    def clients_revenue
      metrics_by_client.map(&:revenue).sum
    end
  
    def cost
      days = days_in_period_for_team_member(employee)
      proration_percent = (days/365)
      hours = proration_percent * BASELINE_TARGET_HOURS_PER_PERSON # whatever target hours were used to determine cost per hour
      employee.cost_per_hour * hours # cost of employee over this timeframe
    end

    def revenue_attributable_to_employee
      # revenue attributable to the employee over this timeframe
      # based on % of effort on the project
      @revenue ||= metrics_by_client.sum do |client_key_metrics|
        client_key_metrics.team_member_percent * client_key_metrics.revenue
      end
    end

    def clients_percent_of_hours
      metrics_by_client.map(&:percent_of_team_members_hours).sum
    end

    def clients_effective_rate
      return 0 unless metrics_by_client.any?
      clients_revenue / metrics_by_client.map(&:hours_billed).sum
    end

    def clients_gross_cost
      metrics_by_client.map(&:gross_cost).sum
    end

    def clients_gross_profit
      clients_revenue - clients_gross_cost
    end

    def clients_gross_profit_percentage
      return 0 unless metrics_by_client.any?
      clients_gross_profit / clients_revenue
    end

    def clients_net_cost
      metrics_by_client.map(&:net_cost).sum
    end

    def clients_net_profit
      clients_revenue - clients_net_cost
    end

    def clients_net_profit_percentage
      clients_net_profit / clients_revenue
    end


    private

    def set_employee_time_entries
      time_entries.where(team_member_id: employee.id)
    end    
  end
end
