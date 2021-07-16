FactoryGirl.define do
  factory :team_member do
    first_name "MyString"
    last_name "MyString"
    harvest_id 1
    is_contractor false
    email "MyString"
    is_active false
  end
end
