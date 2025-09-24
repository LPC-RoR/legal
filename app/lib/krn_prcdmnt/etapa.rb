# app/lib/krn_prcdmnt/etapa.rb
module KrnPrcdmnt
  class Etapa
    attr_reader :nombre, :tareas

    def initialize(nombre, &block)
      @nombre = nombre
      @tareas = []
      instance_eval(&block)
    end

    def tarea(nombre, si:, entonces:)
      @tareas << Tarea.new(
        nombre: nombre,
        condicion: Regla.new(si),
        accion: Regla.new(entonces)
      )
    end

    def activa?(denuncia)
      tareas.any? { |t| t.pendiente?(denuncia) }
    end

    def plazo(proc)
      @plazo = proc
    end

    # Lee la fecha límite ya registrada (la usa el motor más adelante)
    def plazo_para(denuncia)
      @plazo&.call(denuncia)
    end

  end
end