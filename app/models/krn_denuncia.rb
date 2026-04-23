class KrnDenuncia < ApplicationRecord

	DT = 'Dirección del Trabajo'.freeze

	ACCTN = 'dnncs'.freeze

	RECEPTORES = ['Empresa', 'Empresa externa', 'Dirección del Trabajo'].freeze
	MOTIVOS = ['Acoso laboral', 'Acoso sexual', 'Violencia en el trabajo ejercida por terceros'].freeze

	VIAS_DENUNCIA = ['Presencial', 'Correo electrónico', 'Plataforma'].freeze
	TIPOS_DENUNCIANTE = ['Denunciante', 'Representante'].freeze
	TIPOS_DENUNCIA = ['Escrita', 'Verbal'].freeze

	CMBND_PDF_LST = [
	  'dnnc', 'denuncia', 'acta',
	  'notificacion',
	  'certificado',
	  'dvlcn_slctd', 'dvlcn_rslcn',
	  'denuncia_corregida',
	  'txt_infrm',
	  'pronunciamiento',
	  'medidas_sanciones'
	].freeze

	PROC = 'krn_invstgcn'

	belongs_to :ownr, polymorphic: true

	belongs_to :krn_empresa_externa, optional: true

	has_many :krn_denunciantes, 	-> { order(created_at: :asc) }, dependent: :destroy
	has_many :krn_denunciados, 		-> { order(created_at: :asc) }, dependent: :destroy
	has_many :krn_testigos, 		-> { order(created_at: :asc) }, dependent: :destroy

	has_many :act_archivos, as: :ownr, dependent: :destroy
	has_many :act_referencias, as: :ref

	has_many :check_realizados, as: :ownr, dependent: :destroy
	has_many :check_auditorias, as: :ownr, dependent: :destroy
	has_many :audit_notas, as: :ownr, dependent: :destroy

	# KrnTexto se usa para guardar texto personalizado para ser insertado en los reportes
	# el campo 'codigo' es el código del reporte
	has_many :krn_textos, as: :ownr, dependent: :destroy
	accepts_nested_attributes_for :krn_textos, allow_destroy: true

	has_many :rep_archivos, as: :ownr, dependent: :destroy

	has_many :notas, as: :ownr, dependent: :destroy
	
	has_many :krn_derivaciones, -> { order(created_at: :asc) }, dependent: :destroy
	has_many :krn_declaraciones, -> { order(created_at: :asc) }, dependent: :destroy

	has_many :krn_inv_denuncias, -> { order(created_at: :asc) }, dependent: :destroy
	has_many :krn_investigadores, through: :krn_inv_denuncias

#	enum etapa: { recepcion: 0, investigacion: 1, informe: 2, pronunciamiento: 3, aplicacion: 4 }

	scope :ordr, -> { order(fecha_hora: :desc, id: :desc) }

	delegate :rut, :razon_social, to: :krn_empresa_externa, prefix: true
	delegate :razon_social, :plan_type, to: :ownr, prefix: true, allow_nil: true

    validates_presence_of :identificador
	validates :fecha_hora, presence: true, unless: :new_record?
	validates :krn_empresa_externa_id, presence: true, if: -> { receptor_denuncia == 'Empresa externa' }
	validates :tipo_declaracion, presence: true, if: -> { via_declaracion == 'Presencial' }
	validates :representante, presence: true, if: -> { presentado_por == 'Representante' }

	validate :licencia_valida

	include Cptn
	include DnncPlzs
	include DnncMthds
	include DnncProc
	include Fls
	include ActsChecks

	def kywrd
		{
			rol: 	'denuncia',
			abrev: 	"dnnc-#{id}",
			sym: 	:dnnc,
			krn: 	"dnnc-#{id}-2"
		}
	end

	def self.estrctr
		includes(
			krn_denunciantes: [:krn_testigos, :krn_declaraciones],
			krn_denunciados: [:krn_testigos, :krn_declaraciones],
			krn_inv_denuncias: [], krn_derivaciones: []
			)
	end

	def sym
		:dnnc
	end

	def dnnc
		self
	end

	def invstgdr_activo
		krn_inv_denuncias&.last&.objetado ? nil : krn_inv_denuncias.last
	end

	def dflt_bck_rdrccn
		"/cuentas/#{self.ownr.class.name[0].downcase}_#{self.ownr.id}/dnncs"
	end

	# ------------------------------------------------------------------ CDGS_PRTCPNTS
	# app/models/krn_denuncia.rb
	def cdgs_prtcpnts
	  # Precarga en 3 queries: denunciantes + testigos + denunciados + testigos
	  self.class.preload(self, 
	    krn_denunciantes: :krn_testigos,
	    krn_denunciados: :krn_testigos
	  )

	  {}.tap do |hash|
	    procesar_tipo(hash, krn_denunciantes, 'DNNCNT')
	    procesar_tipo(hash, krn_denunciados, 'DNNCD')
	  end
	end

	def procesar_tipo(hash, registros, prefijo)
	  registros.each do |registro|
	    # Registro principal (denunciante/denunciado)
	    agregar_metadatos(hash, registro, prefijo)
	    
	    # Testigos asociados
	    registro.krn_testigos.each do |testigo|
	      agregar_metadatos(hash, testigo, 'TSTG')
	    end
	  end
	end

	def agregar_metadatos(hash, registro, prefijo)
	  # Nombre: código específico por ID
	  if (valor = registro.nombre.to_s.strip).present?
	    hash[valor] = { 
	      codigo: "[#{prefijo}-#{registro.id}-NOMBRE]",
	      tipo: :nombre
	    }
	  end
	  
	  # RUT: código genérico
	  if (valor = registro.rut.to_s.strip).present?
	    hash[valor] = { 
	      codigo: "[PRTCPNT-RUT-CI]",
	      tipo: :rut
	    }
	  end
	  
	  # Email: código genérico
	  if (valor = registro.email.to_s.strip).present?
	    hash[valor] = { 
	      codigo: "[PRTCPNT-EMAIL]",
	      tipo: :email
	    }
	  end
	  
	  # Cargo: código genérico
	  if (valor = registro.cargo.to_s.strip).present?
	    hash[valor] = { 
	      codigo: "[PRTCPNT-CARGO]",
	      tipo: :cargo
	    }
	  end
	  
	  # Domicilio: código genérico
	  if (valor = registro.direccion_notificacion.to_s.strip).present?
	    hash[valor] = { 
	      codigo: "[PRTCPNT-DOMICILIO]",
	      tipo: :domicilio
	    }
	  end
	end
	# ------------------------------------------------------------------ CDGS_PRTCPNTS

	# KrnDenuncia
	def destinatarios(rprt)
	  # bloque re-utilizable
	  build_hash = ->(obj) { { objt: obj, email: (ownr.demo? ? ownr.email_administrador : obj.email), nombre: obj.nombre } }

	  [].tap do |list|
	    # 1) denunciantes y sus testigos
	    krn_denunciantes.includes(:krn_testigos).find_each do |denunciante|
	    	if ClssPdfRprt.cntrl_dstntrs[:krn_denunciantes].include?(rprt)
		    	list << build_hash.call(denunciante) unless denunciante.articulo_516
	    	end
	    	if ClssPdfRprt.cntrl_dstntrs[:krn_testigos].include?(rprt)
	    		denunciante.krn_testigos.find_each { |t| list << build_hash.call(t) unless t.articulo_516 }
	    	end
	    end

	    # 2) denunciados y sus testigos
	    krn_denunciados.includes(:krn_testigos).find_each do |denunciado|
	    	if ClssPdfRprt.cntrl_dstntrs[:krn_denunciados].include?(rprt)
	    		list << build_hash.call(denunciado) unless denunciado.articulo_516
	    	end
	    	if ClssPdfRprt.cntrl_dstntrs[:krn_testigos].include?(rprt)
	    		denunciado.krn_testigos.find_each { |t| list << build_hash.call(t) unless t.articulo_516 }
	    	end
	    end

	  end
	end

	# ------------------------------------------------------------------------ MOTIVOS

	def laboral?
		motivo_denuncia == MOTIVOS[0]
	end

	def sexual?
		motivo_denuncia == MOTIVOS[1]
	end

	def violencia?
		motivo_denuncia == MOTIVOS[2]
	end

	# ------------------------------------------------------------------------ RECEPTOR DE LA DENUNCIA

	def rcp_empresa?
		receptor_denuncia == RECEPTORES[0]
	end

	def rcp_externa?
		receptor_denuncia == RECEPTORES[1]
	end

	def rcp_dt?
		receptor_denuncia == RECEPTORES[2]
	end

	# ------------------------------------------------------------------------ RCPS & DRVS

	private
	
	def licencia_valida
		lic = ownr.licencia_actual
		errors.add(:base, 'No tienes licencia activa')               and return unless lic
		errors.add(:base, 'Licencia expirada')                       and return if lic.expirada?
		errors.add(:base, 'Has alcanzado el límite de denuncias')    and return if lic.tope_alcanzado?
	end

end
