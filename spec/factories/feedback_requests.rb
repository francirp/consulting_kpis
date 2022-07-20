FactoryBot.define do
  factory :feedback_request do
    surveyable { contact }
    date { Date.today }
  end
end
