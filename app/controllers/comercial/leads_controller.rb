class Comercial::LeadsController < ApplicationController

  before_action :set_lead, only: %i[show update]

  # Tercera capa anti-bot: máximo 5 envíos por IP cada 3 minutos
  rate_limit to: 5, within: 3.minutes, only: :create,
             with: -> { redirect_to root_path, alert: "Demasiados intentos, inténtalo más tarde." }

  def index
    @estado = params[:estado]
    @leads  = Lead.order(created_at: :desc)
    @leads  = @leads.where(estado: @estado) if @estado.present?

    # Contadores para las pestañas del pipeline
    @conteos = Lead.group(:estado).count
  end

  def show; end

  def create
    @objeto = Lead.new(lead_params)
    @objeto.fuente = params[:fuente].presence || "formulario_web"

    # El diagnóstico tarda más que 3 segundos en completarse en humanos;
    # un bot que lo envíe rápido cae aquí igual que en el formulario simple.
    if spam? || too_fast?
      # Respuesta idéntica al éxito: no le decimos al bot que lo detectamos
      responder({ ok: true }) and return
    end

    if @objeto.save
      Comercial::LeadMailer.with(lead: @objeto).nuevo_lead.deliver_later
      responder({ ok: true }, notice: "¡Gracias! Te contactaremos en menos de 24 horas.") and return
    else
      responder({ ok: false, errors: @objeto.errors.full_messages },
                alert: "Revisa los datos ingresados (nombre, email y teléfono son obligatorios).") and return
    end
  end

  def update
    if @lead.update(lead_params)
      redirect_to admin_leads_path(estado: @lead.estado),
                  notice: "Lead actualizado a «#{@lead.estado.humanize}»."
    else
      redirect_to admin_leads_path, alert: "No se pudo actualizar el lead."
    end
  end

  def gracias; end

  private

  def set_lead
    @lead = Lead.find(params[:id])
  end

  def lead_params
    # Rails 8: params.expect. respuestas: {} permite valores escalares arbitrarios
    # bajo lead[respuestas][clave] (las 3 respuestas del diagnóstico).
    params.expect(lead: [:kind, :nombre, :email, :telefono, :empresa_nombre, :pregunta, { respuestas: {} }])
  end

  def responder(datos, flash_msg = {})
    respond_to do |format|
      format.html { redirect_to leads_gracias_path, flash_msg }
      format.json { render json: datos, status: datos[:ok] ? :created : :unprocessable_entity }
    end
  end

  # Capa 1: honeypot — un humano nunca lo completa
  def spam?
    params[:website].present?
  end

  # Capa 2: tiempo mínimo — menos de 3 segundos = bot casi seguro
  def too_fast?
    params[:form_loaded_at].blank? ||
      (Time.current.to_i - params[:form_loaded_at].to_i) < 3
  end
end