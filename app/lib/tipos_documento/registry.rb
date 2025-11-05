# app/services/tipos_documento/registry.rb
module TiposDocumento
  REGISTRY = {
    "demanda" => TiposDocumento::Demanda,
    "ley"     => TiposDocumento::Ley
    # add more here
  }.freeze

  def self.registry
    REGISTRY
  end
  
  # Método para obtener la clase por tipo
  def self.obtener_clase(tipo)
    REGISTRY[tipo.to_s]
  end
end