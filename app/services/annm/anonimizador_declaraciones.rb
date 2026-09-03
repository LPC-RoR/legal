# app/services/annm/anonimizador_declaraciones.rb
module Annm
  class AnonimizadorDeclaraciones
    def initialize(denuncia)
      @denuncia = denuncia
      @diccionario = Annm::DiccionarioParticipantes.new(denuncia).mapa_reemplazos
      @reemplazador = Annm::ReemplazadorHtml.new(@diccionario)
      @generico     = Annm::AnonimizadorGenerico.new
    end

    # Paso 1: reemplazo exacto de datos de participantes (rápido, determinista)
    # Paso 2: LLM para elementos genéricos restantes
    def anonimizar(html)
      Rails.logger.info "[Annm::AnonimizadorDeclaraciones] Diccionario: #{@diccionario.size} entradas"
      
      paso_1 = @reemplazador.reemplazar(html)
      paso_2 = @generico.anonimizar(paso_1)
      
      paso_2
    end
  end
end