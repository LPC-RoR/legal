class MFormato < ApplicationRecord

	TIPOS_DATO = ['string', 'fecha', 'hora', 'número', 'pesos', 'UF']

	TABLA_FIELDS  = [
		's#m_formato',
		'inicio',
		'termino'
	]

	belongs_to :m_banco

	has_many :m_datos
	has_many :m_elementos
	has_many :m_cuentas

end
