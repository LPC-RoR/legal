# app/services/tipos_documento/ley.rb
module TiposDocumento
  class Ley < TipoDocumento
    def procesar!
      texto = @service.send(:extraer_texto_pdf)
      return false if texto.blank?

      generar_articulos(texto)
      generar_resumen_ley(texto)
      generar_vigencia(texto)
      true
    end

    private

    def generar_articulos(texto)
      prompt = build_articulos_prompt(texto)
      resp   = chat(prompt)
      crear_act_texto(
        tipo:     "articulos",
        titulo:   "Artículos – Ley #{@service.act_archivo.id}",
        contenido: resp.dig("choices", 0, "message", "content")
      )
    end

    def generar_resumen_ley(texto); … end
    def generar_vigencia(texto);   … end

    def build_articulos_prompt(texto); … end
  end
end