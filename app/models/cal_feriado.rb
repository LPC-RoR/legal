class CalFeriado < ApplicationRecord

	scope :fecha_ordr, -> {order(:cal_fecha)}
end
