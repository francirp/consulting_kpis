FactoryBot.define do
  factory :timesheet do
    team_member { nil }
    week { "2021-10-25" }
    non_working_days { 1.5 }
    status { 1 }
  end
end
