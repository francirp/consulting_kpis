class AsanaProject < ApplicationRecord
  has_many :tasks, class_name: 'AsanaTask'
  belongs_to :client

  scope :archived, -> { where(archived: true) }
  scope :active, -> { where.not(archived: true) }
  scope :not_ignored, -> { where(ignore: [false, nil]) }
  scope :assigned, -> { not_ignored.active.where.not(client_id: nil) }
  scope :needs_assigned, -> { not_ignored.active.where(client_id: nil) }

  after_update :update_asana_tasks
  before_save :update_archived_status, if: :saved_change_to_ignore?

  private

  def update_asana_tasks
    tasks.update_all(client_id: client_id)
  end

  def update_archived_status
    self.archived = true
  end
end
