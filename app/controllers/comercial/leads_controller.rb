module Comercial
  class LeadsController < ApplicationController
    # El pipeline de seguimiento requiere sesión; create, gracias y
    # confirmar son públicos.
    before_action :authenticate_usuario!, only: %i[index show update]
    before_action :set_lead,             only: %i[show update]

    rate_limit to: 5, within: 3.minutes, only: :create,
               with: -> { redirect_to root_path, alert: 'Demasiados intentos, inténtalo más tarde.' }

    # Solo fuentes que el sistema reconoce; cualquier otra cosa que
    # venga manipulada del formulario se normaliza a formulario_web.
    FUENTES_PERMITIDAS = %w[hero cta_final diagnostico simulador presentacion formulario_web].freeze

    def index
      @estado = params[:estado]
      @leads = Lead.order(created_at: :desc)
      @leads = @leads.where(estado: @estado) if @estado.present?
      @conteos = Lead.group(:estado).count
    end

    def show; end

    def update
      if @lead.update(gestion_params)
        redirect_to leads_path(estado: @lead.estado),
                    notice: "Lead actualizado a «#{@lead.estado.humanize}»."
      else
        redirect_to leads_path, alert: 'No se pudo actualizar el lead.'
      end
    end

    # ---- Captura pública ----

    def create
      @objeto = Lead.new(lead_params)
      @objeto.estado        = :nuevo
      @objeto.fuente        = FUENTES_PERMITIDAS.include?(params[:fuente]) ? params[:fuente] : 'formulario_web'
      @objeto.remote_ip     = request.remote_ip
      @objeto.user_agent    = request.user_agent.to_s.first(500)

      redirect_to gracias_leads_path and return if spam? || too_fast?

      if @objeto.save
        # 1) Aviso interno (sin cambios)
        Comercial::LeadMailer.with(lead: @objeto).nuevo_lead.deliver_later

        # 2) ÚNICO correo al lead en este punto: pedir confirmación.
        #    Nada más se envía hasta que abra el enlace del token.
        Comercial::LeadMailer.with(lead: @objeto).confirmacion_email.deliver_later

        respond_to do |format|
          format.html do
            redirect_to gracias_leads_path(pendiente_confirmacion: true),
                        notice: '¡Gracias! Te enviamos un correo para confirmar tu dirección y activar tu solicitud.'
          end
          format.json { render json: { ok: true, pendiente_confirmacion: true } }
        end
      else
        respond_to do |format|
          format.html do
            redirect_to gracias_leads_path,
                        alert: 'Revisa los datos ingresados (nombre, email y teléfono son obligatorios).'
          end
          format.json do
            render json: { errors: @objeto.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end

    def confirmar
      @objeto = Lead.find_by(confirmacion_token: params[:token])

      if @objeto.nil?
        redirect_to root_path, alert: 'Enlace de confirmación inválido o expirado.'
      elsif @objeto.email_confirmado?
        # Re-apertura del enlace: no repetir correos ni encolar jobs
        redirect_to gracias_leads_path(conv: conversion_kind(@objeto))
      else
        @objeto.confirmar_email!

        # Acá sí se cumple la promesa del formulario:
        if @objeto.diagnostico?
          Comercial::LeadMailer.with(lead: @objeto).resultado_diagnostico.deliver_later
        else
          Comercial::LeadMailer.with(lead: @objeto).bienvenida.deliver_later
        end

        Comercial::LeadMailer.with(lead: @objeto).nueva_pregunta.deliver_later if @objeto.pregunta.present?

        # La secuencia de seguimiento solo parte con correo confirmado
        Comercial::ProgramarSeguimientoJob.perform_later(@objeto)

        redirect_to gracias_leads_path(conv: conversion_kind(@objeto)),
                    notice: 'Correo confirmado. Recibirás tu resultado en tu bandeja.'
      end
    end

    def gracias
      respond_to do |format|
        format.html
        format.json { head :ok }
      end
    end

    private

    def conversion_kind(lead)
      lead.diagnostico? ? 'diagnostico' : 'contacto'
    end

    def set_lead
      @lead = Lead.find(params[:id])
    end

    # :fuente sale de la whitelist de arriba, ya no se acepta del form.
    # :estado sigue prohibido (evita auto-marcarse convertido).
    def lead_params
      params.expect(lead: [:nombre, :email, :telefono, :empresa, :empresa_nombre,
                           :pregunta, :kind,
                           { respuestas: %i[denuncia_abierta investigador_actual informe_dt] }])
    end

    def gestion_params
      params.expect(lead: %i[estado nota_seguimiento])
    end

    def spam?
      params[:website].present?
    end

    def too_fast?
      params[:form_loaded_at].blank? ||
        (Time.current.to_i - params[:form_loaded_at].to_i) < 3
    end
  end
end
