class HlpPaso < ApplicationRecord

	belongs_to :hlp_tutorial

	validates :orden, :paso, :detalle, presence: true
	validates :orden, numericality: { only_integer: true }

end
