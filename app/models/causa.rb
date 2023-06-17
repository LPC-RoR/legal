class Causa < ApplicationRecord
	# Tabla de CAUSAS
	# pertenece a tar_tarifa

	TIPOS=['Juicio', 'Demanda']

	TABLA_FIELDS = 	[
		'created_at',
		'd_id',
		's#causa',
		'cliente:razon_social'
#		'tipo_causa:tipo_causa'
	]

	belongs_to :cliente
	belongs_to :tribunal_corte
	belongs_to :tar_tarifa, optional: true

	belongs_to :tipo_causa

    validates_presence_of :causa, :rit

	def tarifas_cliente
		self.cliente.tarifas
	end

	def tarifas_hora_cliente
		self.cliente.tarifas_hora
	end

	def valores
		TarValor.where(owner_class: 'Causa', owner_id: self.id)
	end

	def facturaciones
		TarFacturacion.where(owner_class: 'Causa', owner_id: self.id)
	end

	def facturado_pesos
		uf = TarUfSistema.find_by(fecha: DateTime.now)
		monto = 0
		unless uf.blank?
			self.facturaciones.each do |factnes|
				monto += factnes.moneda == 'Pesos' ? factnes.monto : (factnes.monto * uf.valor)
			end
		end
		monto
	end

	def facturado_uf
		uf = TarUfSistema.find_by(fecha: DateTime.now)
		monto = 0
		unless uf.blank?
			self.facturaciones.each do |factnes|
				monto += factnes.moneda == 'Pesos' ? (factnes.monto / uf.valor) : factnes.monto
			end
		end
		monto
	end

	def enlaces
		AppEnlace.where(owner_class: self.class.name, owner_id: self.id)
	end

	def repo
    	AppRepo.where(owner_class: self.class.name).find_by(owner_id: self.id)
	end

	def reportes
		reportes_clase = RegReporte.where(owner_class: self.class.name)
		reportes_clase.blank? ? nil : reportes_clase.where(owner_id: self.id)
	end

	def registros
    	Registro.where(owner_class: self.class.name, owner_id: self.id)
	end

	def valores_cuantia
		TarValorCuantia.where(owner_class: self.class.name, owner_id: self.id)
	end

	def fecha_calculo
#		self.fecha_uf.blank? ? DateTime.now.to_date : self.fecha_uf.to_date
		self.fecha_uf.blank? ? Time.zone.today : self.fecha_uf.to_date
	end

	def uf_calculo
		uf = TarUfSistema.find_by(fecha: self.fecha_calculo)
		uf.blank? ? nil : uf.valor
	end

	def cuantia_pesos(pago)
		uf = self.uf_pago(pago.tar_pago)
		v = self.valores_cuantia.map { |vc| (vc.moneda == 'Pesos' ? vc.valor : (uf.blank? ? 'Sin UF' : vc.valor * uf.valor)) }
		v.include?('Sin UF') ? 'No hay UF del Día' : v.sum
	end

	def cuantia_uf(pago)
		uf = self.uf_pago(pago.tar_pago)
		v = self.valores_cuantia.map { |vc| (vc.moneda == 'Pesos' ? (uf.blank? ? 'Sin UF' : vc.valor / uf.valor) : vc.valor) }
		v.include?('Sin UF') ? 'No hay UF del Día' : v.sum
	end

	def v_cuantia
		[self.valores_cuantia.map {|vc| vc.valor}.sum, self.valores_cuantia.map {|vc| vc.valor_uf}.sum]
	end

	def as_owner
		self.causa
	end

	def d_id
		self.rit.blank? ? ( self.rol.blank? ? self.identificador : "#{self.rol} : #{self.era}") : self.rit
	end

	def uf_facturaciones
		TarUfFacturacion.where(owner_class: self.class.name, owner_id: self.id)
	end

	def fecha_uf_pago(nombre_pago)
		uf_facturacion = self.uf_facturaciones.find_by(pago: nombre_pago)
		uf_facturacion.blank? ? Time.zone.today : uf_facturacion.fecha_uf
	end

	def uf_pago(nombre_pago)
		TarUfSistema.find_by(fecha: self.fecha_uf_pago(nombre_pago).to_date)
	end

end
