# Preview all emails at http://localhost:3000/rails/mailers/contact
class ContactPreview < ActionMailer::Preview
  def send_feedback_request
    client = Client.find_by(name: 'dummy-client') || FactoryBot.create(:client, name: 'dummy-client')
    contact = Contact.find_by(first_name: 'Dummy') || FactoryBot.create(:contact, client: client, first_name: 'Dummy')
    @feedback_request = FactoryBot.create(:feedback_request, contact: contact)
    ContactMailer.send_feedback_request("ryan@launchpadlab.com", @feedback_request.id)
  end
end
