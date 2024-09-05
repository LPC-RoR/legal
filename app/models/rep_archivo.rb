class RepArchivo < ApplicationRecord
  belongs_to :ownr, polymorphic: true
  belongs_to :rep_doc_controlado, optional: true

  scope :ordr, -> { order(:rep_archivo) }

  require 'carrierwave/orm/activerecord'
  mount_uploader :archivo, RepArchivoUploader

  def self.get_dc_archv(dc)
    find_by(rep_doc_controlado_id: dc.id)
  end

  def cntrld?
    self.rep_doc_controlado_id.present?
  end

end
