class ClientsController < ApplicationController
  before_action :set_filters
  
  def index    
    @key_metrics = Reporting::KeyMetrics.new(@filter)
  end
end
