class FeedbackRequestDecanter < Decanter::Base
  input :rating, :integer
  input :comment, :string
  input :communication, :boolean
  input :management, :boolean
  input :results, :boolean
  input :team, :boolean
  input :timeline, :boolean
  input :other, :boolean
end
