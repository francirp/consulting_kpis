class Api::V1::TimeEntriesController < Api::ApplicationController
  before_action :set_filter

  def index
    respond_to do |format|
      format.json {
        render json: { entries: @filter.all }
      }
    end
  end

  def team_billable
    respond_to do |format|
      format.json {
        render json: @filter.billable_hours_by_team_member
      }
    end
  end

  private

    def set_filter
      @filter = TimeEntryFilter.new(decanted_params)
    end

    def decanted_params
      TimeEntry.decant(params)
    end
end
