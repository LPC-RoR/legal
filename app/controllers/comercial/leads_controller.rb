module Comercial
  class LeadsController < ApplicationController
    # El pipeline de seguimiento requiere sesión; create y gracias son públicos.
    # Ajusta el nombre del método según tu mapping de Devise (tu modelo es Usuario,
    # así que probablemente sea authenticate_usuario!)
    before_action :authenticate_usuario!, only: %i[index show update]
    before_action :set_lead,             only: %i[show update]

    rate_limit to: 5, within: 3.minutes, only: :create,
               with: -> { redirect_to root_path, alert: "Demasiados intentos, inténtalo más tarde." }

    # ---- Seguimiento (privado) ----

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
        redirect_to leads_path, alert: "No se pudo actualizar el lead."
      end
    end

    # ---- Captura pública ----

    def create
      @objeto = Lead.new(lead_params)
      @objeto.estado = :nuevo
      @objeto.fuente = params[:fuente].presence || "formulario_web"

      if spam? || too_fast?
        redirect_to gracias_leads_path and return
      end

      if @objeto.save
        Comercial::LeadMailer.with(lead: @objeto).nuevo_lead.deliver_later

        if @objeto.diagnostico?
          Comercial::LeadMailer.with(lead: @objeto).resultado_diagnostico.deliver_later
        end

        if @objeto.pregunta.present?
          Comercial::LeadMailer.with(lead: @objeto).nueva_pregunta.deliver_later
        end

        respond_to do |format|
          format.html do
            redirect_to gracias_leads_path,
                        notice: "¡Gracias! Te enviamos tu resultado por correo y te contactaremos en menos de 24 horas."
          end
          format.json { render json: { ok: true } }
        end
      else
        respond_to do |format|
          format.html do
            redirect_to gracias_leads_path,
                        alert: "Revisa los datos ingresados (nombre, email y teléfono son obligatorios)."
          end
          format.json do
            render json: { errors: @objeto.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end

    def gracias
      respond_to do |format|
        format.html
        format.json { head :ok }
      end
    end
    
    private

    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Params del formulario público: NUNCA estado (evita que alguien se auto-marque convertido)
    def lead_params
      params.expect(lead: [:nombre, :email, :telefono, :empresa, :empresa_nombre,
                           :pregunta, :kind, :fuente,
                           { respuestas: %i[denuncia_abierta investigador_actual informe_dt] }])
    end

    # Params de gestión interna
    def gestion_params
      params.expect(lead: [:estado, :nota_seguimiento])
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