# app/services/concerns/anonimizacion_prompt.rb
module AnonimizacionPrompt
  extend ActiveSupport::Concern

  private

  def construir_prompt_anonimizacion(texto, nombres_hash)
    prompt = +"DOCUMENTO A ANONIMIZAR (mantén TODO el texto, solo reemplaza datos personales):\n\n#{texto}\n\n"

    if nombres_hash.any?
      prompt << "MAPA DE ANONIMIZACIÓN DE NOMBRES (reemplaza EXACTAMENTE estos nombres por los alias indicados):\n"
      nombres_hash.each do |nombre_real, alias_anonimo|
        prompt << "- \"#{nombre_real}\" → \"#{alias_anonimo}\"\n"
      end
      prompt << "\n"
    end

    prompt << <<~INSTRUCCIONES
      REGLAS DE ANONIMIZACIÓN DE DATOS PERSONALES:

      1. NOMBRES DE PERSONAS:
         - Si están en el mapa anterior, úsalos.
         - Si no: denunciante → "Denunciante", denunciado → "Denunciado", testigo → "Testigo A/B", etc.

      2. CÉDULAS DE IDENTIDAD / RUT (FORMATO: XX.XXX.XXX-Y o XX.XXX.XXX-y):
         - Ejemplos: 10.956.337-4, 10.879.738-k, 13.288.761-6, 17.941.232-2
         - Reemplaza TODAS las ocurrencias por: "[CEDULA DE IDENTIDAD/RUT]"
         - El formato es: números con punto de miles, guión, y dígito verificador (0-9 o K/k)

      3. CORREOS ELECTRÓNICOS:
         - Reemplaza TODAS las direcciones de email por: "[EMAIL]"
         - Ejemplo: alguien@empresa.cl → "[EMAIL]"

      4. OTROS DATOS SENSIBLES:
         - Direcciones exactas, teléfonos → omítelos o anonimízalos.

      5. FORMATO:
         - Devuelve el documento COMPLETO, sin resumir.
         - Usa HTML: <p> para párrafos, <br> para saltos de línea.
         - NO markdown. NO <html/head/body>. Solo contenido en <article>.
    INSTRUCCIONES

    prompt
  end
end