FactoryBot.define do
  factory :client do
    name { "MyString" }
    active { false }
    sequence :harvest_id do |n|
      n + 100000
    end    
  end
end
