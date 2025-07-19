class Slide < ApplicationRecord

	has_one_attached :imagen

	scope :activas, -> { where(desactivar: [nil, false]) }
	scope :ordr, -> { order(:orden) }

	include OrderModel

	def ownr
		nil
	end

	def self.list
		Slide.activas.ordr
	end

	def list
		Slide.activas.ordr
	end

	def redireccion
		"/slides"
	end
end
