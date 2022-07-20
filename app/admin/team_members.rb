ActiveAdmin.register TeamMember do
  permit_params :first_name, :last_name, :is_contractor, :email,
                :is_active, :start_date, :end_date, :billable_target_ratio,
                :cost_per_hour, :first_feedback_request_date, :send_surveys

  scope :active, default: true
  scope :inactive
  scope :all

  remove_filter :time_entries

  config.sort_order = 'first_name_asc'

  batch_action :enroll_in_pulse_surveys, form: {  
    first_feedback_request_date: :datepicker
  } do |ids, inputs|
    team_members = batch_action_collection.where(id: ids)
    date = inputs[:first_feedback_request_date]
    team_members.update_all(
      first_feedback_request_date: date,
      send_surveys: true,
    )    
    redirect_back(fallback_location: collection_path, alert: "The selected Team Members have been enrolled in pulse surveys starting #{date}.")
  end

  batch_action :remove_from_pulse_surveys do |ids, inputs|
    team_members = batch_action_collection.where(id: ids)
    team_members.update_all(
      send_surveys: false,
    )    
    redirect_back(fallback_location: collection_path, alert: "The selected Team Members have been removed from pulse surveys.")
  end   
end
