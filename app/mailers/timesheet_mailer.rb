class TimesheetMailer < ActionMailer::Base
  default from: "casejamesc@gmail.com"

  def email_report(pdf, recipient)
    attachments["invoice.pdf"] = pdf if pdf.present?
    mail subject: 'Your Invoice', to: recipient
  end
end
