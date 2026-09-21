class Lead < ApplicationRecord
  KINDS = %w[presentacion diagnostico].freeze

  # ---------------------------------------------------------------
  # Mini-diagnóstico: ÚNICA fuente de verdad de textos.
  # La usa el wizard del home (_diagnostico.html.erb) y el correo
  # resultado_diagnostico. NO cambiar los `valor` ("si", "interno", ...):
  # se guardan en respuestas (jsonb) y los usa con_denuncia_abierta.
  # ---------------------------------------------------------------
  DIAGNOSTICO_PREGUNTAS = [
    {
      clave: "denuncia_abierta",
      texto: "¿Su empresa tiene hoy una denuncia por acoso, violencia o discriminación en curso?",
      opciones: {
        "si" => {
          etiqueta: "Sí, tenemos una denuncia abierta",
          feedback: "La Ley 21.643 impone plazos estrictos. La investigación de la denuncia tiene un plazo de 30 días hábiles contados a partir de la fecha de rececpión de la denuncia. Los tramites propios de la recepción de la denuncia el trámite de informar a la Dirección del Trabajo el inicio de la investigación, deben realizarse dentro de los 3 primeros días hábiles."
        },
        "tramite" => {
          etiqueta: "Estamos evaluando una denuncia recién recibida",
          feedback: "En este minuto el foco es cumplir con los trámites propios de la recepción de la denuncia e informar el inicio de la investigación dentro de los 3 primeros días hábiles. Es el mejor momento para decidir la expernalización de la investigación."
        },
        "no" => {
          etiqueta: "No tenemos denuncias en curso",
          feedback: "La ley obliga a estar preparado igual: la mayoría de las empresas descubre sus vacíos recién con la primera denuncia."
        }
      }
    },
    {
      clave: "investigador_actual",
      texto: "¿Quién realizaría hoy las investigaciones de esas denuncias?",
      opciones: {
        "interno" => {
          etiqueta: "Un equipo interno (jurídico o RR.HH.)",
          feedback: "Un investigador interno puede ser objetado por las partes por falta de imparcialidad. Un investigador externo, especialista en la ley, prácticamente elimina ese riesgo."
        },
        "externo" => {
          etiqueta: "Un proveedor externo",
          feedback: "Revise tres cosas: que el investigador sea abogado especialista en la Ley 21.643, que el procedimiento tenga control documental y que provea control de plazos legales."
        },
        "nadie" => {
          etiqueta: "Nadie está asignado a eso",
          feedback: "Esto puede indicar que su empresa no cuenta con el Protocolo de prevención del acoso laboral, sexual y la violencia en el trabajo ejercida por terceros. Verifique la existencia del protocolo, y que los trabajadores encargados del canal de denuncias y el equipo de investigadores tengan el perfil y la capacitación necesaria."
        }
      }
    },
    {
      clave: "informe_dt",
      texto: "¿Ha informado o sabría hoy cómo informar a la Dirección del Trabajo el inicio de una investigación?",
      opciones: {
        "si" => {
          etiqueta: "Sí, conocemos el trámite",
          feedback: "Entonces el foco está en ejecutar la investigación con estándares que resistan una eventual judicialización."
        },
        "parcial" => {
          etiqueta: "Lo conocemos parcialmente",
          feedback: "Es el escenario más común: la ley es reciente y el reglamento tiene exigencias específicas por trámite. Un error de forma puede invalidar el esfuerzo posterior."
        },
        "no" => {
          etiqueta: "No lo conocemos",
          feedback: "Nuestro servicio incluye la capacitación en la implementación de los trámites que se realizan en la plataforma de la Dirección del Trabajo. También ofrecemos nuestra plataforma tecnológica para la generación automatizada de notificaciones y documentación obligatoria, además de su envío automatizado a los participantes de la denuncia."
        }
      }
    }
  ].freeze


  belongs_to :empresa, optional: true

  enum :estado, {
    nuevo: 0,
    contactado: 1,
    calificado: 2,
    convertido: 3,
    descartado: 4
  }

  validates :nombre, :email, :telefono, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :kind, inclusion: { in: KINDS }
  validates :pregunta, length: { maximum: 2000 }

  scope :pendientes, -> { where(estado: %i[nuevo contactado calificado]) }
  scope :diagnosticos, -> { where(kind: "diagnostico") }

  # Prioridad comercial: diagnósticos con una denuncia abierta real
  scope :con_denuncia_abierta, -> { diagnosticos.where("respuestas ->> 'denuncia_abierta' = 'si'") }

  def diagnostico?
    kind == "diagnostico"
  end

  def respuesta(clave)
    respuestas[clave.to_s]
  end

  # Etiqueta legible de la respuesta elegida ("externo" → "Un proveedor externo")
  def respuesta_legible(clave)
    self.class.diagnostico_pregunta(clave)
        &.dig(:opciones, respuesta(clave), :etiqueta) || respuesta(clave) || "—"
  end

  # Indicación que se desplegó en el wizard al elegir esa respuesta
  def feedback_respuesta(clave)
    self.class.diagnostico_pregunta(clave)
        &.dig(:opciones, respuesta(clave), :feedback)
  end

  def self.diagnostico_pregunta(clave)
    DIAGNOSTICO_PREGUNTAS.find { |p| p[:clave] == clave.to_s }
  end

  # Solo se llama cuando la gestión comercial fue exitosa.
  # RUT y razón social se piden aquí, no en el formulario público.
  def convertir_a_empresa!(rut:, razon_social:, usuario_asignado: nil, **empresa_attrs)
    raise "Lead ya convertido" if convertido?

    transaction do
      empresa = Empresa.create!(
        rut: rut,
        razon_social: razon_social,
        nombre_contacto: nombre,
        email_contacto: email,
        telefono_contacto: telefono,
        **empresa_attrs
      )
      update!(estado: :convertido, empresa: empresa)
      empresa
    end
  end
end