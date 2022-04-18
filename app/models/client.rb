class Client < ApplicationRecord
  has_many :projects
  has_many :invoices
  has_many :asana_projects
  has_many :asana_tasks, through: :asana_projects
end
