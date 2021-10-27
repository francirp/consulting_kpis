FactoryBot.define do
  factory :task do
    is_active { false }
    harvest_id { 1 }
    billable_by_default { false }
    name { "MyString" }
    is_default { false }
  end
end
