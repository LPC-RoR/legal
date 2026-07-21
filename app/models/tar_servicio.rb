class TarServicio < ApplicationRecord

	belongs_to :ownr, polymorphic: true, optional: true

	has_many :asesorias

    validates_presence_of :descripcion, :tipo, :moneda, :monto

end
