class ClientsController < ApplicationController
  before_action :set_filters
  
  def index    
    @key_metrics = Reporting::KeyMetrics.new(@filter)
  end

  def show
    @client = Client.find(params[:id])
    @client_key_metrics = Reporting::ClientKeyMetrics.new(@filter, @client)
  end
end
