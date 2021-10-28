class ClientsController < ApplicationController
  before_action :set_filters
  
  def index
    @clients = Client.all.order("name ASC")
    invoices = Invoice.non_retainers.between(@start_date, @end_date).group_by(&:client_id)
    @key_metrics = Reporting::KeyMetrics.new(@filter)
    time_entries = @filter.time_entries.includes(:team_member).joins(:team_member)
    binding.pry
    @clients_key_metrics = @clients.map do |client|
      Reporting::ClientKeyMetrics.new(
        @filter,
        client,
        time_entries: time_entries.where(client_id: client.id),
        invoices: invoices[client.id]
      )
    end.sort_by(&:revenue).reverse
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
