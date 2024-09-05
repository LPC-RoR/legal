class RepDocControlado < ApplicationRecord
  TIPOS = ['Documento', 'Archivo']
  CONTROLES = ['Requerido', 'Opcional']

  belongs_to :ownr, polymorphic: true

  has_many :rep_archivos

  scope :ordr, -> { order(:orden) }
  scope :ordr_doc, -> { order(:rep_doc_controlado) }

  include OrderModel

  def self.get_archv(codigo)
    find_by(codigo: codigo)
  end

  # ------------------------------------ ORDER LIST

  def list
    self.ownr.rep_doc_controlados.ordr
  end

  def redireccion
    case self.ownr_type
    when 'TarDetalleCuantia'
      "/tablas?tb=7"
    when 'StModelo'
      self.ownr
    end
  end

  # -----------------------------------------------

end
