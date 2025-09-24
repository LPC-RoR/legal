# app/lib/krn_prcdmnt.rb
module KrnPrcdmnt
  class << self
    def for(denuncia)
      etapa_actual = Definicion.etapas.find { |e| e.activa?(denuncia) }
      return NullEtapa.new if etapa_actual.nil?

      tarea_actual = etapa_actual.tareas.find { |t| t.pendiente?(denuncia) }
      OpenStruct.new(
        etapa:        etapa_actual.nombre,
        tarea:        tarea_actual&.nombre,
        objeto_tarea: tarea_actual,
        completo?:    etapa_actual.nil?,
        plazo:        etapa_actual.plazo_para(denuncia)
      )
    end
  end

  class NullEtapa
    def nombre  = :krn_completo
    def tarea   = nil
    def completo? = true
    def plazo     = nil
  end
end