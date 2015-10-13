class Harvest::HarvestClient < Harvest::Wrapper

  attr_reader :client_wrapper

  def after_init(args = {})
    @client_wrapper = args[:client_wrapper]
  end

  def to_h
    {
      harvest_id: client_wrapper.id,
      name: client_wrapper.name,
      active: client_wrapper.active,
      harvest_updated_at: client_wrapper.updated_at,
      harvest_created_at: client_wrapper.created_at,
      statement_key: client_wrapper.statement_key,
      details: client_wrapper.details

    }
  end

  def find_or_build
    ::Client.find_by_harvest_id(client_wrapper.id) || ::Client.new
  end

end