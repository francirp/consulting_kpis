class Harvest::HarvestTimeEntry < Harvest::Wrapper

  attr_reader :harvest_time_entry

  def after_init(entry)
    @harvest_time_entry = entry
  end

  def to_h
    {
      spent_at: harvest_time_entry.spent_at,
      harvest_id: harvest_time_entry.id,
      notes: harvest_time_entry.notes,
      hours: harvest_time_entry.hours,
      harvest_user_id: harvest_time_entry.user_id,
      harvest_project_id: harvest_time_entry.project_id,
      harvest_task_id: harvest_time_entry.task_id,
      harvest_created_at: harvest_time_entry.created_at,
      harvest_updated_at: harvest_time_entry.updated_at,
      is_billed: harvest_time_entry.is_billed,
      harvest_invoice_id: harvest_time_entry.invoice_id
    }
  end

end