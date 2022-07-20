require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "self.all_ready_for_feedback_request" do
    subject { Contact.all_ready_for_feedback_request.count }

    let(:first_feedback_request_date) { Date.current }
    let(:send_surveys) { true }
    let(:recent_feedback_request_date) { Date.current - 14.days }

    let!(:contact) do
      create(:contact,
        first_feedback_request_date: first_feedback_request_date, # start date is in the past, so we should send
        send_surveys: send_surveys,
        recent_feedback_request_date: recent_feedback_request_date,
      )
    end      
    
    context "when ready to send" do
      it { is_expected.to eq(1) }
    end

    context "when start date is not reached" do
      let(:first_feedback_request_date) { Date.current + 1.day }
      it { is_expected.to eq(0) }
    end

    context "when recent feedback request date is less than two weeks" do
      let(:recent_feedback_request_date) { Date.current - 13.days }
      it { is_expected.to eq(0) }
    end
    
    context "when send_surveys is false" do
      let(:send_surveys) { false }
      it { is_expected.to eq(0) }
    end    
  end
end
