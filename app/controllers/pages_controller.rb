class PagesController < ApplicationController
  before_action :set_filters

  def dashboard
    @key_metrics = Reporting::KeyMetrics.new(
      start_date: @start_date,
      end_date: @end_date,
    )

    @key_metrics_no_contractors = Reporting::KeyMetrics.new(
      start_date: @start_date,
      end_date: @end_date,
      employment_type: 'Employee'
    )
  end

  def update_report
    result = ReportDecanter.decant(params[:report])
    session[:start_date] = result[:start_date] if result[:start_date]
    session[:end_date] = result[:end_date] if result[:end_date]
    redirect_back fallback_location: dashboard_path
  end
end
