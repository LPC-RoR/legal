# Preview all emails at http://localhost:3000/rails/mailers/empresa_mailer
class EmpresaMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/empresa_mailer/verification_email
  def verification_email
    EmpresaMailer.verification_email
  end
end
