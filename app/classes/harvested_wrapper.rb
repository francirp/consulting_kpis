class HarvestedWrapper
  attr_reader :harvest

  def initialize(args = {})
    subdomain = args.fetch(:subdomain, ENV["HARVEST_SUBDOMAIN"])
    username = args.fetch(:username, ENV["HARVEST_USERNAME"])
    password = args.fetch(:password, ENV["HARVEST_PASSWORD"])
    @harvest = Harvest.client(subdomain: subdomain, username: username, password: password)
    after_init(args)
    require_fields
  end

  def projects
    @projects ||= harvest.projects.all
  end

  def clients
    @clients ||= harvest.clients.all
  end

  def users
    @users ||= harvest.users.all
  end

  def find_client(client_id)
    clients.detect {|client| client.id == client_id }
  end

  private

    def after_init(args = {})
      # implemented by subclasses
    end

    def require_fields
      required_fields.each do |attr|
        raise "#{attr} is a required param for #{self.class.name} class" if send(attr).nil?
      end
    end

    def required_fields
      []
    end

end
