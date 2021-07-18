class ClientsController < ApplicationController
  before_action :set_filters
  
  def index
    @clients = Client.all.order("name ASC")
    @invoices = Invoice.non_retainers.between(@start_date, @end_date).group_by(&:client_id)

    # exporter = ExportData::ToCsv.new(clients: @clients)

    # respond_to do |format|
    #   format.html
    #   format.csv do
    #     send_data exporter.to_csv
    #   end
    # end
  end

  # def show
  #   @project = Project.find(params[:id]).decorate
  # end
end
