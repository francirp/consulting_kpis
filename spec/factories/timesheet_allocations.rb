FactoryBot.define do
  factory :timesheet_allocation do
    timesheet { nil }
    allocation { 1.5 }
    project { nil }
    description { "MyText" }
  end
end
