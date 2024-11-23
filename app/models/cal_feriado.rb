class CalFeriado < ApplicationRecord

	scope :fecha_ordr, -> {order(:cal_fecha)}
	scope :lv, -> {where(tipo: 'lv')}

end
