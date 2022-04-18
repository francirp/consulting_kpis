ActiveAdmin.register AsanaProject do
  permit_params :name, :client_id, :archived, :ignore  
  config.sort_order = "name_asc"
  scope :all, default: true
  scope :assigned
  scope :needs_assigned

  remove_filter :tasks

  batch_action :assign, form: {  
    client: Client.order("name ASC").pluck(:name, :id),
  } do |ids, inputs|
    client = Client.find(inputs[:client])
    projects = batch_action_collection.where(id: ids)     
    projects.each do |project|
      project.client_id = client.id
      project.save
    end
    redirect_back(fallback_location: collection_path, alert: "The Asana projects have been assigned to #{client.name}.")
  end  

  batch_action :ignore do |ids|
    batch_action_collection.where(id: ids).update_all(ignore: true)
    redirect_back(fallback_location: collection_path, alert: "The Asana projects have been ignored.")
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :client, as: :select
      f.input :archived
      f.input :ignore
    end
    f.actions
  end
end
