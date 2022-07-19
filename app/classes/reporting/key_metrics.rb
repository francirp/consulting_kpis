module Reporting
  class KeyMetrics
    extend Memoist
    POTENTIAL_HOURS_PER_YEAR_PER_PERSON = 1572
    ER_TARGET = 160.0
    NET_UTILIZATION_TARGET = 0.83
    OVERHEAD_FACTOR = 1.48
    attr_reader :filter
    delegate :start_date, :end_date, :employment_type, :billable,
             :time_entries, :contractors, :employees, :invoices,
             :time_entries_by_team_member_id, :time_entries_by_client_id,
             :invoices_by_client_id, :completed_tasks_by_client_id, to: :filter

    def initialize(filter)
      @filter = filter
    end
    
    def hours_billed
      @hours_billed ||= time_entries.sum(:rounded_hours).round(2)
    end

    def revenue
      @revenue ||= invoices.sum(:amount).round(2)
    end

    def effective_rate
      revenue / hours_billed
    end

    def metrics_by_employee
      array = employees.map do |employee|
        employee_time_entries = time_entries_by_team_member_id[employee.id] || []
        EmployeeKeyMetrics.new(
          filter,
          employee,
          time_entries: employee_time_entries,
        )
      end
      array.reject! { |e| e.not_active? }
      array.compact
    end
    memoize :metrics_by_employee

    def clients
      @clients ||= Client.where(id: time_entries.distinct.pluck(:client_id)).order("name ASC")
    end

    def metrics_by_client
      clients.map do |client|
        client_time_entries = time_entries_by_client_id[client.id] || []
        client_completed_tasks = completed_tasks_by_client_id[client.id] || []
        client_invoices = invoices_by_client_id[client.id] || []
        ClientKeyMetrics.new(
          filter,
          client,
          time_entries: client_time_entries,
          invoices: client_invoices,
          tasks: client_completed_tasks,
        )
      end
    end
    memoize :metrics_by_client

    def utilization
      hours_billed / available_hours_of_employees
    end

    def hours_miss
      target_hours_of_employees - hours_billed
    end

    def miss_in_revenue_from_hours_miss
      hours_miss * ER_TARGET
    end    

    def available_hours_of_employees
      @available_hours_of_employees ||= begin
        metrics_by_employee.sum do |employee_metrics|
          employee_metrics.available_hours
        end
      end
    end
    
    def target_hours_of_employees
      @target_hours_of_employees ||= begin
        metrics_by_employee.sum do |employee_metrics|
          employee_metrics.target_hours
        end
      end
    end

    def net_available_hours_of_employees
      @net_available_hours_of_employees ||= begin
        metrics_by_employee.sum do |employee_metrics|
          employee_metrics.net_available_hours
        end
      end
    end

    # target is 83%
    def net_utilization
      hours_billed / net_available_hours_of_employees
    end

    def target_hours_variance_percentage
      (hours_billed / target_hours_of_employees) - 1
    end

    def effective_rate_variance_percentage
      (effective_rate / 160.0) - 1
    end
    
    def hours_variance
      hours_billed - target_hours_of_employees
    end

    def percent_of_team_members_hours
      1
    end

    def gross_cost
      @gross_cost ||= time_entries.sum("rounded_hours * team_members.cost_per_hour")
    end

    def gross_profit
      @gross_profit ||= revenue - gross_cost
    end

    def gross_profit_percentage
      gross_profit / revenue
    end

    def net_cost
      @net_cost ||= gross_cost * OVERHEAD_FACTOR
    end

    def net_profit
      revenue - net_cost
    end

    def net_profit_percentage
      net_profit / revenue
    end

    def dev_days
      metrics_by_client.map(&:dev_days).sum
    end
    memoize :dev_days

    def velocity
      ((dev_days / hours_billed) * 100).round(1)
    end
  end
end