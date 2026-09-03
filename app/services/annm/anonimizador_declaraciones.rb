# app/services/annm/anonimizador_declaraciones.rb
module Annm
  class AnonimizadorDeclaraciones
    def initialize(denuncia)
      @denuncia = denuncia
      @diccionario = Annm::DiccionarioParticipantes.new(denuncia).mapa_reemplazos
      @reemplazador = Annm::ReemplazadorHtml.new(@diccionario)
      @generico = Annm::AnonimizadorGenerico.new
    end

    def anonimizar(html)
      html = html.to_s
      return "" if html.blank?

      Rails.logger.info "[Annm::AnonimizadorDeclaraciones] === INICIO ==="
      Rails.logger.info "[Annm::AnonimizadorDeclaraciones] HTML length: #{html.length} | class: #{html.class}"

      paso_1 = @reemplazador.reemplazar(html)

      # Diagnóstico: buscar si quedaron nombres propios sueltos
      nombres_sueltos = paso_1.scan(/\b[A-ZÁÉÍÓÚÑ][a-záéíóúñ]{2,}\b/).uniq.first(20)
      Rails.logger.info "[Annm::AnonimizadorDeclaraciones] Nombres sueltos post-paso1: #{nombres_sueltos.join(', ')}"

      # Si quedaron muchos nombres sueltos, el paso 1 falló
      if nombres_sueltos.size > 5
        Rails.logger.warn "[Annm::AnonimizadorDeclaraciones] ALERTA: #{nombres_sueltos.size} nombres sueltos detectados. El paso 1 probablemente falló."
      end

      paso_2 = @generico.anonimizar(paso_1)

      Rails.logger.info "[Annm::AnonimizadorDeclaraciones] === FIN ==="
      paso_2
    end
  end
end