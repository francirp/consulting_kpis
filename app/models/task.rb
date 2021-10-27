class Task < ApplicationRecord
  scope :active, -> { where(is_active: true) }

  PRIMARY_TASKS = [
    'Account Management',
    'Design',
    'Development',
    'Product',
    'Project Management',
  ]

  def self.primary_tasks
    Task.where(name: PRIMARY_TASKS)
  end
end
