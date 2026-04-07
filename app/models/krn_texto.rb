# app/models/krn_texto.rb
class KrnTexto < ApplicationRecord
  belongs_to :krn_denuncia
  
  # Reemplaza tu campo 'texto' por contenido enriquecido
  has_rich_text :contenido
  
  validates :codigo, presence: true, uniqueness: { scope: :krn_denuncia_id }
  
  # Helper para renderizado consistente
  def to_html
    contenido.to_s
  end
  
  # Extraer texto plano para búsquedas/previews
  def to_plain_text
    contenido.to_plain_text
  end
end