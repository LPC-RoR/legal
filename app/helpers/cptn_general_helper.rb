module CptnGeneralHelper
	def s_pesos(valor)
		number_to_currency(valor, locale: :en, precision: 0)
	end

	def s_pesos2(valor)
		number_to_currency(valor, locale: :en, precision: 2)
	end

	def dma(date)
		date.blank? ? '' : date.strftime("%d-%m-%Y")
	end

end