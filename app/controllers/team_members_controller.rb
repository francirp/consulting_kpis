class TeamMembersController < ApplicationController
  before_action :set_filters
  
  def index
    @filter.employment_type = 'Employee'
    @key_metrics = Reporting::KeyMetrics.new(@filter)
    @metrics_by_employee = @key_metrics.metrics_by_employee
  end

  def show
    @team_member = TeamMember.find(params[:id])
    @employee_key_metrics = Reporting::EmployeeKeyMetrics.new(@filter, @team_member)
  end
end
