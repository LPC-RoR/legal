class Comercial::LeadsController < ApplicationController

  # Tercera capa anti-bot: máximo 5 envíos por IP cada 3 minutos
  rate_limit to: 5, within: 3.minutes, only: :create,
             with: -> { redirect_to root_path, alert: "Demasiados intentos, inténtalo más tarde." }

  def create
    @objeto = Lead.new(lead_params)
    @objeto.fuente = params[:fuente].presence || "formulario_web"

    if spam? || too_fast?
      # Respuesta idéntica al éxito: no le decimos al bot que lo detectamos
      redirect_to leads_gracias_path and return
    end

    if @objeto.save
      Comercial::LeadMailer.with(lead: @objeto).nuevo_lead.deliver_later
      redirect_to leads_gracias_path, notice: "¡Gracias! Te contactaremos en menos de 24 horas."
    else
      redirect_to leads_gracias_path,
                  alert: "Revisa los datos ingresados (nombre, email y teléfono son obligatorios)."
    end
  end

  def gracias; end

  private

  def lead_params
    params.expect(lead: [:nombre, :email, :telefono, :empresa])
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