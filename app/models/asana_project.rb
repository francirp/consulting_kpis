class AsanaProject < ApplicationRecord
  has_many :tasks, class_name: 'AsanaTask'

  scope :archived, -> { where(archived: true) }
  scope :active, -> { where.not(archived: true) }
end
