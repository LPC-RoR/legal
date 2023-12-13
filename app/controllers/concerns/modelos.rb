module Modelos
	extend ActiveSupport::Concern

	def modelo_negocios_general
      general_sha1 = Digest::SHA1.hexdigest("Modelo de Negocios General")
      modelo = MModelo.find_by(m_modelo: general_sha1)
      modelo = MModelo.create(m_modelo: general_sha1) if modelo.blank?
      modelo
	end

	def cuentas_corrientes
      modelo_negocios_general.m_cuentas.order(:m_cuentas)
	end

	def periodos
		MPeriodo.all.order(clave: :desc)
	end
end