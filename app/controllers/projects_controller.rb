class ProjectsController < ApplicationController

  def index
    @clients = Client.includes(:projects).all
    exporter = ExportData::ToCsv.new(clients: @clients)

    respond_to do |format|
      format.html
      format.csv do
        send_data exporter.to_csv
      end
    end
  end

  def show
    @project = Project.find(params[:id]).decorate
  end

end
