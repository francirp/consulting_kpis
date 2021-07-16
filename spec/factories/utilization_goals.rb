FactoryBot.define do
  factory :utilization_goal do
    team_member {nil}
    annualized_hours {1}
    start_date {"2021-07-15"}
    end_date {"2021-07-15"}
  end
end
