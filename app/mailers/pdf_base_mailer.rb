# Context Mail
class PdfBaseMailer < ApplicationMailer

  def enviar_pdf(asunto:)
    @act_archivo  = params[:act_archivo]
    @datos_layout = params[:datos_layout]
    destinatario  = params[:destinatario]
    @contexto = ClssPdf.context_for(@act_archivo.act_archivo)

    if @act_archivo.pdf.attached?
      attachments[@act_archivo.pdf.filename.to_s] = @act_archivo.pdf.download
    end

    preparar_logo

    # Configura branding si es invstgcns (usa empresa relacionada)
    configurar_branding if @contexto == :invstgcns

    codigo   = @act_archivo.act_archivo

    mail(to: destinatario, subject: asunto) do |format|
      format.html do
        render(
          template: template_para_codigo,
          layout:   layout_para_contexto
        )
      end
    end
  end

  private

  # --------------------------------------------------------------------------
  # Logo inline para el header del email
  # --------------------------------------------------------------------------
  def preparar_logo
    logo_data = if @contexto == :invstgcns
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

  # --------------------------------------------------------------------------
  # Branding para contexto invstgcns
  # --------------------------------------------------------------------------
  def configurar_branding
    empresa = @act_archivo.ownr&.emprs
    return unless empresa

    # Crea un objeto branding simple compatible con los helpers del ApplicationMailer
    @branding = OpenStruct.new(
      logo_url: logo_url_desde_empresa(empresa),
      footer_html: "<p>#{empresa.razon_social}</p>",
      brand_name: empresa.razon_social,
      support_email: 'no-reply@laborsafe.cl'
    )
  end

  def logo_url_desde_empresa(empresa)
    return nil unless empresa.logo.attached?
    # Usa la URL de ActiveStorage con las opciones configuradas
    empresa.logo.url
  end

  # --------------------------------------------------------------------------
  # Resolución de template y layout
  # --------------------------------------------------------------------------
  def template_para_codigo
    codigo = @act_archivo.act_archivo
    template_especifico = "mail_templates/#{@contexto}/#{codigo}"

    if template_exists?(template_especifico, [], false)
      template_especifico
    else
      "mail_templates/#{@contexto}/enviar_pdf"
    end
  end

  def layout_para_contexto
    "mail_layouts/#{@contexto}/lyt"
  end
end