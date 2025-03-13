class RepArchivo < ApplicationRecord
  belongs_to :ownr, polymorphic: true
  belongs_to :rep_doc_controlado, optional: true

  scope :ordr, -> { order(:rep_archivo) }
  scope :crtd_ordr, -> { order(created_at: :desc) }
  scope :updtd_ordr, -> { order(:updated_at) }

  scope :hm_archvs, -> {where(ownr_type: nil, ownr_id: nil)}

  validates :fecha, presence: true, if: -> {control_fecha}
  validates :archivo, presence: true, unless: -> {chequeable}
  validates_presence_of :rep_archivo
  validates_presence_of :nombre, if: -> {dc_multiple?}

  require 'carrierwave/orm/activerecord'
  mount_uploader :archivo, RepArchivoUploader

  def self.get_dc_archv(dc)
    find_by(rep_doc_controlado_id: dc.id)
  end

  def cntrld?
    self.rep_doc_controlado_id.present?
  end

  def dc_multiple?
    self.rep_doc_controlado_id.blank? ? false : (self.rep_doc_controlado.multiple == true)
  end

end
