ActiveAdmin.register TeamMember do
  permit_params :first_name, :last_name, :is_contractor, :email,
                :is_active, :start_date, :end_date, :billable_target_ratio,
                :task_id

  scope :active, default: true
  scope :inactive
  scope :all

  remove_filter :time_entries

  config.sort_order = 'first_name_asc'

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :start_date
      f.input :end_date
      f.input :billable_target_ratio, hint: "As a decimal: 1.0, 0.75, 0.5, etc."
      f.input :task, label: "Default Task", as: :select, collection: Task.primary_tasks
      f.input :is_contractor
      f.input :is_active
    end
    f.actions
  end
end
