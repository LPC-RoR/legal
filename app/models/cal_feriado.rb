class CalFeriado < ApplicationRecord

	scope :fecha_ordr, -> {order(:cal_fecha)}
	scope :lv, -> {where(tipo: 'lv')}

    validates_presence_of :cal_fecha, :descripcion
#	validates :tribunal_corte, uniqueness: true

end
