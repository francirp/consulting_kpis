require 'rails_helper'

RSpec.describe Contract, type: :model do
  let(:team_member) { build(:team_member) }
  subject { build(:contract, team_member: team_member) }
  it { is_expected.to be_valid }
end
