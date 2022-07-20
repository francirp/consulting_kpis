class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@launchpadlab.com'
  layout 'mailer'
  DEV_EMAIL = "ryan@launchpadlab.com"

  def email_for_environment(email)
    Rails.env.production? ? email : DEV_EMAIL
  end
end
