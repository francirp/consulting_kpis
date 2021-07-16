require 'rails_helper'

RSpec.describe UtilizationGoal, type: :model do
  let(:team_member) { build(:team_member) }
  subject { build(:utilization_goal, team_member: team_member) }
  it { is_expected.to be_valid }
end
