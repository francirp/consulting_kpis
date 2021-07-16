require 'rails_helper'

RSpec.describe TeamMember, type: :model do
  subject { build(:team_member) }
  it { is_expected.to be_valid }
end
