class RepArchivo < ApplicationRecord
  belongs_to :ownr, polymorphic: true
  belongs_to :rep_doc_controlado, optional: true

  scope :ordr, -> { order(:rep_archivo) }
  scope :updtd_ordr, -> { order(:updated_at) }

  scope :hm_archvs, -> {where(ownr_type: nil, ownr_id: nil)}

  validates_presence_of :rep_archivo, :archivo
  validates_presence_of :nombre, if: -> {mltpl?}

  require 'carrierwave/orm/activerecord'
  mount_uploader :archivo, RepArchivoUploader

  def self.get_dc_archv(dc)
    find_by(rep_doc_controlado_id: dc.id)
  end

  def cntrld?
    self.rep_doc_controlado_id.present?
  end

  def mltpl?
    self.rep_doc_controlado_id.blank? ? false : (self.rep_doc_controlado.multiple == true)
  end

end
