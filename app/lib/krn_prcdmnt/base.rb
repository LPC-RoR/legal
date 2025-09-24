# app/lib/krn_prcdmnt/base.rb
module KrnPrcdmnt
  class Base
    class << self
      attr_accessor :etapas
    end

    def self.etapa(nombre, &block)
      self.etapas ||= []
      self.etapas << Etapa.new(nombre, &block)
    end
  end
end