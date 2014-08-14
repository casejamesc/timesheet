class TimesheetMailer < ActionMailer::Base
  default from: "casejamesc@gmail.com"

  def email_report(pdf)
    attachments["invoice.pdf"] = pdf if pdf.present?
    mail subject: 'Your Invoice', to: 'samilcrouch@gmail.com'
  end
end
