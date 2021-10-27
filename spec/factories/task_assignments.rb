FactoryBot.define do
  factory :task_assignment do
    project { nil }
    task { nil }
    is_active { false }
  end
end
