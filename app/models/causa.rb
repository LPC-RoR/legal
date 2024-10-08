class Causa < ApplicationRecord

	include PgSearch

	pg_search_scope :search_for, against: {
		causa: 'A',
		rit: 'B'
	}, using: { tsearch: {prefix: true, any_word: true} }

	CALC_VALORES = [ 
		'#cuantia_pesos', '#cuantia_uf', '#monto_pagado', '#monto_pagado_uf', '#facturado_pesos', '#facturado_uf',
		'$Remuneración'
	]

	belongs_to :cliente
	belongs_to :tribunal_corte
	belongs_to :tar_tarifa, optional: true

	belongs_to :tipo_causa

	has_many :temas
	has_many :hechos
	has_many :demandantes

	has_many :causa_archivos
	has_many :app_archivos, through: :causa_archivos

	has_many :secciones
	has_many :parrafos
	has_many :estados
	has_many :monto_conciliaciones

	has_many :age_actividades, as: :ownr


	# antecedentes de los hechos de la tabla
	has_many :antecedentes

    validates_presence_of :causa, :rit

    scope :std, ->(estado) { where(estado: estado).order(:fecha_audiencia)}

    # OWN CHILDS

    # CUANTIA

    def notas
    	Nota.where(ownr_clss: self.class.name, ownr_id: self.id)
    end

    def agenda
    	self.actividades.where(tipo: ['Audiencia', 'Hito']).order(fecha: :desc)
    end

	def valores_cuantia
		TarValorCuantia.where(owner_class: self.class.name, owner_id: self.id)
	end

	def cuantia_modificada?
		self.valores_cuantia.map {|vc| vc.activado?}.include?(false)
	end

	def text_cuantia
		self.valores_cuantia.map {|vc| vc.detalle}.join(' ')
	end

	# PAGOS

	def calculos
		TarCalculo.where(ownr_clss: self.class.name, ownr_id: self.id)
	end

	def facturaciones
		TarFacturacion.where(owner_class: self.class.name, owner_id: self.id)
	end

	# Archivos y control de archivos

	def nombres_usados
		self.archivos.map {|archivo| archivo.app_archivo}.union(self.documentos.map {|doc| doc.app_documento})
	end

	def archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end

	def archivos_controlados
		self.tipo_causa.control_documentos.where(tipo: 'Archivo').order(:nombre)
	end

	def archivos_pendientes
		ids = self.archivos_controlados.map {|control| control.id unless self.nombres_usados.include?(control.nombre) }.compact
		ControlDocumento.where(id: ids)
	end

	def demanda
		self.archivos.find_by(app_archivo: 'Demanda')
	end

	def demanda?
		archivo = self.demanda

		archivo.blank? ? false : archivo.archivo.present?
	end
	# ------------------------------------------------------------

	def exclude_files
		self.tipo_causa.blank? ? [] : self.tipo_causa.control_documentos.where(tipo: 'Archivo').order(:nombre).map {|cd| cd.nombre}
	end

	# Documentos y control de documentos
	def documentos
		AppDocumento.where(owner_class: self.class.name, owner_id: self.id)
	end

	def documentos_controlados
		self.tipo_causa.control_documentos.where(tipo: 'Documento').order(:nombre)
	end

	def documentos_pendientes
		ids = self.documentos_controlados.map {|doc| doc.id unless self.nombres_usados.include?(doc.nombre) }.compact
		ControlDocumento.where(id: ids)
	end
	# ----------------------------------------------------------

	def exclude_docs
		self.tipo_causa.blank? ? [] : self.tipo_causa.control_documentos.where(tipo: 'Documento').order(:nombre).map {|cd| cd.nombre}
	end

	# enlaces
	def enlaces
		AppEnlace.where(owner_class: self.class.name, owner_id: self.id)
	end

	# Valores asignados a las variables
	def valores_datos
		Valor.where(owner_class: self.class.name, owner_id: self.id)
	end

	# Actividades
	def actividades
		AgeActividad.where(owner_class: self.class.name, owner_id: self.id).order(fecha: :desc)
	end

	def reportes
		RegReporte.where(owner_class: self.class.name, owner_id: self.id)
	end

	def registros
    	Registro.where(owner_class: self.class.name, owner_id: self.id)
	end

	def uf_facturaciones
		TarUfFacturacion.where(owner_class: self.class.name, owner_id: self.id)
	end

    def child_records?
    	valores_cuantia.any? or
    	facturaciones.any? or
    	archivos.any? or 
    	documentos.any? or
    	enlaces.any? or
    	valores_datos.any? or
    	actividades.any? or
    	reportes.any? or 
    	registros.any? or
    	uf_facturaciones.any?
    end

    # **************************************************** CÁLCULO DE TARIFA [PAGOS]

    def get_valor(variable)
    	variable = Variable.find_by(variable: variable)
	    valor = self.valores_datos.find_by(variable_id: variable.id)
	    variable.tipo == 'Texto' ? valor.c_string : ( variable.tipo == 'Párrafo' ? valor.c_parrafo : valor.c_numero )
    end

    def get_age_actividad(nombre)
    	self.actividades.find_by(age_actividad: nombre)
    end

	def set_valores
		calc_valores = {}

		self.class::CALC_VALORES.each do |class_valor|
			case class_valor[0]
			when '#'
				calc_valores[class_valor] = {}
				unless self.tar_tarifa.blank? or self.tar_tarifa.tar_pagos.empty?
					self.tar_tarifa.tar_pagos.each do |tar_pago|
						if ['#monto_pagado', '#facturado_pesos', '#facturado_uf'].include?(class_valor)
							calc_valores[class_valor][tar_pago.id] = self.send(class_valor.gsub('#', ''))
						else
							calc_valores[class_valor][tar_pago.id] = self.send(class_valor.gsub('#', ''), tar_pago)
						end
					end 
				end 
			when '$'
				valor = self.valor(class_valor.gsub('$', ''))
				calc_valores[class_valor] = valor.blank? ? 0 : valor
			when '@'
				fyc = class_valor.match(/^@(?<facturable>.+):(?<campo>.+)/)
				tar_facturacion = objeto.facturaciones.find_by(facturable: fyc[:facturable])
				calc_valores[class_valor] = tar_facturacion.blank? ? 0 : (tar_facturacion.send(fyc[:campo]).blank? ? 0 : tar_facturacion.send(fyc[:campo]))
			end
		end
		calc_valores
	end

	# Encuentra el PAGO (TarFacturacion) asociado al pago
	def pago_generado(objeto)
		# objeto.class.name {TarPago, TarCuota}
		objeto.class.name == 'TarPago' ? self.facturaciones.find_by(tar_pago_id: objeto.id) : self.facturaciones.find_by(tar_cuota_id: objeto.id)
	end

	# REVISAR --> DEPRECATED : Se remplaza por uf_tacturacion en concerns::tarifas
	# Encuentra la UF de Cálculo (TarUfFacturacion) asociado al pago
	def tar_uf_facturacion(pago)
		self.uf_facturaciones.find_by(tar_pago_id: pago.id)
	end

	def origen_fecha_pago(pago)
		if self.tar_uf_facturacion(pago).present?
			'TarUfFacturacion'
		elsif self.pago_generado(pago).present?
			'TarPago'
		else
			'Today'
		end
	end

	# REVISAR --> DEPRECATED, se agregó fecha_uf a TarFacturacion, en ella se almacenará la fecha de cálculo
	# Ya sea que esta provenga de TarUfFacturacion o sea la fecha de la creación de TarFacturacion
	def fecha_calculo_pago(pago)
		if self.tar_uf_facturacion(pago).present?
			self.tar_uf_facturacion(pago).fecha_uf
		elsif self.pago_generado(pago).present?
			self.pago_generado(pago).created_at
		else
			Time.zone.today.to_date
		end
	end

	def uf_calculo_pago(pago)
		TarUfSistema.find_by(fecha: fecha_calculo_pago(pago))
	end

	def valor(variable_name)
		variable = self.tipo_causa.variables.find_by(variable: variable_name)
		valor = self.valores_datos.find_by(variable_id: variable.id)
		valor
	end

	def facturado_pesos
		self.facturaciones.map {|factn| factn.monto_pesos}.sum
	end

	def facturado_uf
		self.facturaciones.map {|factn| factn.monto_uf}.sum
	end

	# DEPRECATED
	def total_cuantia
		v_pesos = self.valores_cuantia.map {|vc| vc.valor if vc.moneda == 'Pesos'}.compact
		v_uf = self.valores_cuantia.map {|vc| vc.valor if vc.moneda != 'Pesos'}.compact
		[v_pesos.empty? ? 0 : v_pesos.sum, v_uf.empty? ? 0 : v_uf.sum]
	end

	# DEPRECATED
	def cuantia_pesos(pago)
		tc = self.total_cuantia
		uf = self.uf_calculo_pago(pago)
		valor_uf = uf.blank? ? 0 : uf.valor
		tc[0] + tc[1] * valor_uf
	end

	# DEPRECATED
	def cuantia_uf(pago)
		tc = self.total_cuantia
		uf = self.uf_calculo_pago(pago)
		valor_uf = uf.blank? ? 0 : uf.valor
		valor_uf == 0 ? 0 : tc[0] / valor_uf + tc[1]
	end

    # ****************************************************

    def st_modelo
    	StModelo.find_by(st_modelo: self.class.name)
    end

	# Hasta aqui revisado!

	# DEPRECATED
	def valores
		TarValor.where(owner_class: self.class.name, owner_id: self.id)
	end

	def tarifas_cliente
		self.cliente.tarifas
	end

	def monto_pagado_pesos(pago)
		self.monto_pagado
	end

	def monto_pagado_uf(pago)
		uf = self.uf_calculo_pago(pago)
		(uf.blank? or self.monto_pagado.blank?) ? 0 : self.monto_pagado / uf.valor
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

	def detalle_cuantia(moneda)
		valor = self.valores_cuantia.map { |vc| vc.valor if vc.moneda == moneda }.compact.sum
		valor.blank? ? 0 : valor
	end

end
