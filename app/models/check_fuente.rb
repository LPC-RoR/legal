class CheckFuente < ApplicationRecord
	belongs_to :check_realizado
	belongs_to :usuario

 	has_one_attached :pdf

 	validates :fuente, presence: true
end
