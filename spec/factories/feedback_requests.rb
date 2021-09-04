FactoryBot.define do
  factory :feedback_request do
    contact { nil }
    date { Date.today }
  end
end
