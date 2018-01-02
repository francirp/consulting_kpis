require 'rails_helper'

RSpec.describe ChicagoTechEvents::PullEvents, type: :model do
  let(:service) { ChicagoTechEvents::PullEvents.new }

  describe '.pull_events' do
    subject { service.pull_events }

    it 'should return an array' do
      expect(subject).to be_a(Array)
    end
  end
end
