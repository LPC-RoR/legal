# app/mailers/vrfccn_mailer.rb
class VrfccnMailer < ApplicationMailer
  layout 'mailer'

  def verification_email
    # 1) Restaura tenant/contexto si aplica
    if params[:tenant_id].present? && defined?(::Current)
      ::Current.tenant = Tenant.find(params[:tenant_id])
    end

    # 2) Resuelve por clase + id sin default_scopes molestando
    user_class = (params[:user_class] || "User").to_s
    user_id    = params[:user_id]
    @user = user_class.constantize.unscoped.find(user_id)

    # 3) Usa la URL ya construida por el concern
    @verification_url = params[:verification_url]

    mail(
      to: @user.email,
      from: Rails.application.config.x.mail_from,
      subject: 'Por favor verifica tu correo electrónico'
    )
  ensure
    ::Current.reset_all if defined?(::Current) && ::Current.respond_to?(:reset_all)
  end
end
