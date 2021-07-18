ActiveAdmin.register Contract do
  permit_params :is_hourly, :hourly_rate, :salary, :bonus, :total_comp,
                :start_date, :end_date, :team_member_id

end
