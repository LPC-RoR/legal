class Cargo < ApplicationRecord
	belongs_to :tipo_cargo
	belongs_to :cliente

    scope :std, ->(std) { where(estado: std).order(created_at: :desc)}
    scope :typ, ->(typ_id) { where(estado: 'activo', tipo_cargo_id: typ_id).order(created_at: :desc) }
end