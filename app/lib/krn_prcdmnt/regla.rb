# app/lib/krn_prcdmnt/regla.rb
module KrnPrcdmnt
  class Regla
    def initialize(proc)
      @proc = proc
    end

    def call(denuncia)
      denuncia.instance_eval(&@proc)
    end
  end
end