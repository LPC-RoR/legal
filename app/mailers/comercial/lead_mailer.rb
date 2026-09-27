module Comercial
  class LeadMailer < ApplicationMailer
    CORREO_VENTAS = 'ventas@laborsafe.cl'.freeze
    AGENDA_URL    = 'https://www.laborsafe.cl/#contacto'.freeze

    helper_method :agenda_url

    # Aviso interno: cada vez que se crea un lead
    def nuevo_lead
      @lead = params[:lead]

      mail(
        to: Rails.application.config.lead_notification_recipients,
        subject: "Nuevo lead: #{@lead.nombre} (#{@lead.fuente})"
      )
    end

    # ACCIÓN 1 (inmediata): resultado de la autoevaluación al propio lead
    def resultado_diagnostico
      @lead = params[:lead]

      mail(
        to: @lead.email,
        subject: "Su autodiagnóstico Ley 21.643 – resultados y próximos pasos"
      )
    end

    # ACCIÓN 2 (solo si el lead envió pregunta): derivación a ventas
    def nueva_pregunta
      @lead = params[:lead]

      mail(
        to: CORREO_VENTAS,
        reply_to: @lead.email,
        subject: "Pregunta de #{@lead.nombre} – responder dentro de 1 día hábil"
      )
    end

    # Copia de la simulación enviada al propio lead
    def copia_simulacion
      @lead       = params[:lead]
      @fecha_base = params[:fecha_base]
      @plazos     = params[:plazos]
      @total_dias = params[:total_dias]

      mail(
        to: @lead.email,
        subject: "Tu simulación de plazos – Denuncia recibida el #{l(@fecha_base, format: '%d/%m/%Y')}"
      )
    end

    # ACCIÓN (inmediata): bienvenida del formulario simple (kind: presentacion).
    # Cubre la promesa comercial de las 24 horas aunque no haya nadie disponible.
    def bienvenida
      @lead = params[:lead]

      mail(
        to: @lead.email,
        subject: "#{@lead.nombre}, recibimos tu solicitud de demo – el próximo paso"
      )
    end

    # SEGUIMIENTO: un solo método de entrada; la plantilla la elige
    # Comercial::SeguimientoLeadJob mediante params[:tipo] (ver Lead::Segmentacion).
    # No existe una plantilla "seguimiento" genérica: hay una por tipo
    # (seguimiento_agendar, seguimiento_urgencia, ...), por eso el template_name.
    # Desde CORREO_VENTAS: todos los pasos invitan a responder y las respuestas
    # deben caer en un buzón activo.
    def seguimiento
      @lead = params[:lead]
      @tipo = params[:tipo]

      mail(
        from: CORREO_VENTAS,
        to: @lead.email,
        subject: asunto_seguimiento,
        template_name: "seguimiento_#{@tipo}"
      )
    end

    private

    def agenda_url
      AGENDA_URL
    end

    def asunto_seguimiento
      nombre = @lead.nombre

      case @tipo
      when "agendar"
        "¿Agendamos los 30 minutos, #{nombre}?"
      when "urgencia"
        if @lead.respuesta(:denuncia_abierta) == "tramite"
          "#{nombre}, sus primeros 3 días hábiles son críticos"
        else
          "#{nombre}, los plazos de su denuncia siguen corriendo"
        end
      when "prevencion"
        "#{nombre}, la mejor denuncia es la que su empresa está preparada para recibir"
      when "imparcialidad"
        "#{nombre}, la objeción de imparcialidad que puede costarle la investigación"
      when "protocolo"
        "#{nombre}, ¿su protocolo Ley Karin está al día?"
      when "dt"
        "#{nombre}, el trámite ante la Dirección del Trabajo sin tecnicismos"
      else # "cierre"
        "#{nombre}, último correo: su diagnóstico queda disponible"
      end
    end
  end
end