module VerificacionEmails
  extend ActiveSupport::Concern

  def tiene_email_validado?
    check_realizados.exists?(cdg: 'verificar_email',rlzd: true)
  end

  def tiene_email_verificado?
    email == email_ok and email.present? and verification_sent_at.present?
  end

  def envio_habilitado?
    tiene_email_validado? || tiene_email_verificado? || !!articulo_516
  end

end