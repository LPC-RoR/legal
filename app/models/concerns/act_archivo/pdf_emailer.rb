# app/models/concerns/act_archivo/pdf_emailer.rb
module ActArchivo::PdfEmailer
  extend ActiveSupport::Concern

  # ============================================
  # ENVIAR PDF POR EMAIL — SINCRÓNICO Y TRAZABLE
  # ============================================
  # Usar SIEMPRE para documentación legal.
  # deliver_now garantiza que el usuario sabe inmediatamente si falló.
  def enviar_pdf_por_email(destinatario:, asunto:, datos_layout: nil)
    return false unless pdf.attached?

    # 1. Crear trazabilidad
    email_legal = EmailLegal.create!(
      act_archivo:  self,
      ownr:         self.ownr,
      reporte:      self.act_archivo,
      destinatario: destinatario,
      asunto:       asunto,
      estado:       :pendiente
    )

    # 2. Preparar datos para el mailer
    contexto     = ClssPdf.context_for(self.act_archivo)
    layout_data  = datos_layout

    # 3. Enviar sincrónicamente (deliver_now)
    email_legal.update!(estado: :encolado)

    PdfBaseMailer.with(
      act_archivo:  self,
      destinatario: destinatario,
      contexto:     contexto,
      datos_layout: layout_data
    ).enviar_pdf(asunto: asunto).deliver_now

    # 4. Confirmar éxito
    email_legal.update!(estado: :enviado, enviado_en: Time.current)
    true

  rescue => e
    email_legal&.update!(
      estado:   :fallido,
      error:    e.message,
      intentos: email_legal.intentos + 1
    )

    Rails.logger.error "[ActArchivo##{id}] Email NO enviado: #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
    false
  end

  # ============================================
  # REENVIAR PDF YA ENVIADO (para reintentos manuales)
  # ============================================
  def reenviar_pdf_por_email(destinatario:, asunto:, datos_layout: nil)
    enviar_pdf_por_email(destinatario: destinatario, asunto: asunto, datos_layout: datos_layout)
  end

  private

  def asunto_por_defecto
    contexto = ClssPdf.context_for(act_archivo)
    "Documento PDF - #{contexto.to_s.upcase} - #{act_archivo}"
  end

  # ── Carga flexible de objetos según contexto ───────────────────────────────
  def cargar_datos_para_layout(contexto)
    case contexto
    when :invstgcns
      {
        ownr:  ownr,
        dnnc:  ownr.dnnc,
        emprs: ownr.dnnc.ownr
      }
    when :fnnzs
      {
        financiamiento: financiamiento_relacionado,
        presupuesto:    presupuesto_asociado,
        entidad:        entidad_financiera
      }
    when :srvcs
      {
        servicio: servicio_relacionado,
        cliente:  cliente_asociado,
        contrato: contrato_vigente
      }
    when :pltfrm
      {
        plataforma: modulo_asociado,
        usuario:    usuario_solicitante
      }
    else
      {}
    end
  end

  # Placeholders — implementa según tus relaciones reales ????
  def financiamiento_relacionado; end
  def presupuesto_asociado;       end
  def entidad_financiera;         end
  def servicio_relacionado;       end
  def cliente_asociado;           end
  def contrato_vigente;           end
  def modulo_asociado;            end
  def usuario_solicitante;        end
end