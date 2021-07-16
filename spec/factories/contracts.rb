FactoryBot.define do
  factory :contract do
    is_hourly { false }
    hourly_rate { 1.5 }
    salary { 1.5 }
    bonus { 1.5 }
    total_comp { 1.5 }
    start_date { "2021-07-15" }
    end_date { "2021-07-15" }
  end
end
