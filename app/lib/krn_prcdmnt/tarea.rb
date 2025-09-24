# app/lib/krn_prcdmnt/tarea.rb
module KrnPrcdmnt
  Tarea = Struct.new(:nombre, :condicion, :accion, keyword_init: true) do
    def pendiente?(denuncia)
      condicion.call(denuncia)
    end

    def ejecutar!(denuncia)
      accion.call(denuncia)
    end
  end
end