ActiveAdmin.register Timesheet do
  permit_params :team_member_id, :week, :non_working_days, timesheet_allocations_attributes: 
                [:id, :allocation, :project_id, :description, :task_id, :_destroy]

  config.sort_order = 'week_desc'

  controller do
    def edit
    @timesheet = Timesheet.find(params[:id])
      default_task = @timesheet.team_member.task
      project_ids_in_use = @timesheet.timesheet_allocations.map(&:project_id)
      @timesheet.team_member.projects.active.billable.uniq.each do |project|
        next if project_ids_in_use.include?(project.id)
        @timesheet.timesheet_allocations.build(
          project: project,
          allocation: 0.0,          
          task: default_task,          
        )
      end
    end
  end

  action_item :finalize, only: :show, if: proc{ resource.draft? } do
    link_to 'Finalize', finalize_admin_timesheet_path(resource), method: :put, data: { confirm: 'Are you sure you want to finalize this timesheet?' }
  end  

  member_action :finalize, method: :put do
    timesheet = Timesheet.find(params[:id])
    timesheet.finalize
    redirect_to admin_timesheet_path(timesheet), notice: 'Timesheet has been finalized.'
  end  

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :team_member
      f.input :week, as: :datepicker
      f.input :non_working_days, hint: "PTO, Vacation, Holidays, Office Closed, etc."
      if f.object.persisted?
        f.has_many :timesheet_allocations, heading: "Allocate your #{resource.total_hours} hours across projects as a percentage of 100%",
                                          allow_destroy: true,
                                          new_record: false do |a|
          a.input :allocation, label: "#{a.object.project.client.name} - #{a.object.project.name}", hint: "e.g. 0.3, 0.25, etc."
          a.input :project_id, as: :hidden
          a.input :task, as: :select, collection: a.object.project.tasks.active
          a.input :description, as: :text, input_html: { rows: 5 }, hint: "What was the focus of your week? What product facets did you work on generally?  "
        end
      end
    end
    f.actions
  end
end
