class Cargo < ApplicationRecord
	belongs_to :tipo_cargo
	belongs_to :cliente

	scope :crg_ordr, -> { order(created_at: :desc) }

    scope :std, ->(std) { where(estado: std).crg_ordr}
    scope :typ_id, ->(typ_id) { where(estado: 'activo', tipo_cargo_id: typ_id).crg_ordr }
    scope :typ, ->(typ) { where(tipo_cargo_id: TipoCargo.find_by(tipo_cargo: typ).id, estado: 'tramitación').crg_ordr }
end