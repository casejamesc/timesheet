class TimesheetMailer < ActionMailer::Base
  default from: "casejamesc@gmail.com"

  # locals: { email_address: @email_address, date1: @date1, date2: @date2 }

  def email_report(pdf, recipient)
    attachments["invoice.pdf"] = pdf if pdf.present?
    mail subject: 'Your Invoice', to: recipient
  end
end
