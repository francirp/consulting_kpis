FactoryBot.define do
  factory :contact do
    first_name { "Ryan" }
    last_name { "Francis" }
    email { "ryan@launchpadlab.com" }    
    client { nil }
    sequence :harvest_id do |n|
      n
    end
  end
end
