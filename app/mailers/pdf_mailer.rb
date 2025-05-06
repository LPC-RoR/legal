class PdfMailer < ApplicationMailer
  def send_pdf(email, pdf_data, filename, template_name, sbjct)
    attachments[filename] = pdf_data
    mail(
      to: email,
      subject: sbjct,
      template_name: template_name
    )
  end
end