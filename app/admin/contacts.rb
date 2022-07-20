ActiveAdmin.register Contact do
  permit_params :email, :first_feedback_request_date, :send_surveys  

  batch_action :enroll_in_pulse_surveys, form: {  
    first_feedback_request_date: :datepicker
  } do |ids, inputs|
    contacts = batch_action_collection.where(id: ids)
    date = inputs[:first_feedback_request_date]
    contacts.update_all(
      first_feedback_request_date: date,
      send_surveys: true,
    )    
    redirect_back(fallback_location: collection_path, alert: "The selected Contacts have been enrolled in pulse surveys starting #{date}.")
  end

  batch_action :remove_from_pulse_surveys do |ids, inputs|
    contacts = batch_action_collection.where(id: ids)
    contacts.update_all(
      send_surveys: false,
    )    
    redirect_back(fallback_location: collection_path, alert: "The selected Contacts have been removed from pulse surveys.")
  end  
end
