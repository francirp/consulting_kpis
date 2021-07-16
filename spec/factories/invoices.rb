FactoryBot.define do
  factory :invoice do
    issue_date {"2021-07-15"}
    last_payment_date {"2021-07-15"}
    harvest_id {1}
    client {nil}
    amount {1.5}
    period_start {"2021-07-15"}
    period_end {"2021-07-15"}
    state {"MyString"}
    payment_term {"MyString"}
    sent_at {"2021-07-15"}
    paid_date {"2021-07-15"}
  end
end
