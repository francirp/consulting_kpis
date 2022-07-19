ActiveAdmin.register TeamMember do
  permit_params :first_name, :last_name, :is_contractor, :email,
                :is_active, :start_date, :end_date, :billable_target_ratio,
                :cost_per_hour  

  scope :active, default: true
  scope :inactive
  scope :all

  remove_filter :time_entries

  config.sort_order = 'first_name_asc'
end
