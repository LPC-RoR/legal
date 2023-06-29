class MConciliacion < ApplicationRecord

	TABLA_FIELDS = [
		's#created_at',
		'datos',
		'registros'
	]

	belongs_to :m_cuenta

	has_many :m_valores
	has_many :m_registros

	mount_uploader :m_conciliacion, ArchivoUploader

	def datos
		self.m_valores.count == 0 ? '-' : self.m_valores.count
	end

	def registros
		self.m_registros.count == 0 ? '-' : self.m_registros.count
	end

	def total_cartola
		self.m_registros.map {|r| r.monto}.sum
	end

end
