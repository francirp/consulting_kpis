class ReportDecanter < Decanter::Base
  input :start_date, :date
  input :end_date, :date
  input :team_member_id, :integer
end
