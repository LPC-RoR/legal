# Context Mail
class PdfBaseMailer < ApplicationMailer

  def enviar_pdf(asunto:)
    @act_archivo  = params[:act_archivo]
    @datos_layout = params[:datos_layout]
    destinatario  = params[:destinatario]

    if @act_archivo.pdf.attached?
      attachments[@act_archivo.pdf.filename.to_s] = @act_archivo.pdf.download
    end

    preparar_logo

    contexto = ClssPdf.context_for(@act_archivo.act_archivo)
    codigo   = @act_archivo.act_archivo

    mail(to: destinatario, subject: asunto) do |format|
      format.html do
        render(
          template: template_para_codigo(contexto, codigo),
          layout:   "mail_layouts/#{contexto}/lyt"
        )
      end
    end
  end

  private

  def preparar_logo
    contexto = ClssPdf.context_for(@act_archivo.act_archivo)

    logo_data = if contexto == :invstgcns
                  logo_desde_empresa || logo_por_defecto_generico
                else
                  logo_por_defecto_tyc
                end

    attachments.inline['logo.png'] = logo_data if logo_data
  end

  def logo_desde_empresa
    empresa = @act_archivo.ownr&.emprs
    return nil unless empresa&.logo&.attached?

    empresa.logo.download
  end

  def logo_por_defecto_tyc
    path = Rails.root.join('app', 'assets', 'images', 'logo', 'tyc_60.png')
    File.exist?(path) ? File.read(path, mode: 'rb') : nil
  end

  def logo_por_defecto_generico
    path = Rails.root.join('app', 'assets', 'images', 'logo', 'logo_60.png')
    File.exist?(path) ? File.read(path, mode: 'rb') : nil
  end

  # Busca template específico del código, o usa uno base por contexto
  def template_para_codigo(contexto, codigo)
    template_especifico = "mail_templates/#{contexto}/#{codigo}"

    if template_exists?(template_especifico, [], false)
      template_especifico
    else
      # Fallback: template base del contexto
      "mail_templates/#{contexto}/enviar_pdf"
    end
  end
end