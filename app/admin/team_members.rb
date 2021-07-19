ActiveAdmin.register TeamMember do
  permit_params :first_name, :last_name, :is_contractor, :email,
                :is_active, :start_date, :end_date, :billable_target_ratio

  scope :active, default: true
  scope :inactive
  scope :all

  config.sort_order = 'first_name_asc'
end
