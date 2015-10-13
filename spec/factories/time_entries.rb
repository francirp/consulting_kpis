FactoryGirl.define do
  factory :time_entry do
    spent_at "2015-10-12"
harvest_id 1
notes "MyText"
hours 1.5
harvest_user_id 1
harvest_project_id 1
harvest_task_id 1
harvest_created_at "2015-10-12 20:08:08"
harvest_updated_at "2015-10-12 20:08:08"
is_billed false
harvest_invoice_id 1
  end

end
