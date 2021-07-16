def harvesting_client
  @harvesting_client ||= Harvesting::Client.new(
    access_token: ENV["HARVEST_ACCESS_TOKEN"],
    account_id: ENV["HARVEST_ACCOUNT_ID"]
  )
end