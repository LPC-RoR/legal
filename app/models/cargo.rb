class Cargo < ApplicationRecord
	belongs_to :tipo_cargo
	belongs_to :cliente

	has_one :tar_calculo, as: :ownr
	has_one :tar_facturacion, as: :ownr
	has_many :notas, as: :ownr

	scope :crg_ordr, -> { order(created_at: :desc) }

    scope :std, ->(std) { where(estado: std).crg_ordr}
    scope :typ_id, ->(typ_id) { where(estado: 'activo', tipo_cargo_id: typ_id).crg_ordr }
    scope :typ, ->(typ) { where(tipo_cargo_id: TipoCargo.find_by(tipo_cargo: typ).id, estado: 'tramitación').crg_ordr }

    def fecha_uf_facturacion
    	self.fecha_uf? ? self.fecha_uf : Time.zone.today.to_date
    end

    def get_uf_facturacion
    	TarUfSistema.find_by(fecha: self.fecha_uf_facturacion)
    end

    def facturable?
       	self.get_uf_facturacion.present? or self.moneda == 'Pesos'
    end

    def monto_factura
    	self.moneda == 'Pesos' ? self.monto : (self.get_uf_facturacion.blank? ? nil : self.monto * self.get_uf_facturacion.valor)
    end

    def facturable?
    	uf = self.fecha_uf? ? TarUfSistema.find_by(fecha: self.fecha_uf) : TarUfSistema.find_by(fecha: Time.zone.today.to_date)
    	uf.present?
    end

end