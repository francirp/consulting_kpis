class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def set_filters
    @start_date = session.fetch(:start_date, Date.today.beginning_of_year)
    @start_date = Date.parse(@start_date) if @start_date.is_a?(String)
    @end_date = session.fetch(:end_date, (Date.today - 1.month).end_of_month)
    @end_date = Date.parse(@end_date) if @end_date.is_a?(String)
    @filter = Reporting::Filter.new(
      start_date: @start_date,
      end_date: @end_date,
    )
  end
end
