class KrnDenuncia < ApplicationRecord

	DT = 'Dirección del Trabajo'.freeze

	ACCTN = 'dnncs'.freeze

	RECEPTORES = ['Empresa', 'Empresa externa', 'Dirección del Trabajo'].freeze
	MOTIVOS = ['Acoso laboral', 'Acoso sexual', 'Violencia en el trabajo ejercida por terceros'].freeze

	VIAS_DENUNCIA = ['Presencial', 'Correo electrónico', 'Plataforma'].freeze
	TIPOS_DENUNCIANTE = ['Denunciante', 'Representante'].freeze
	TIPOS_DENUNCIA = ['Escrita', 'Verbal'].freeze

	PROC = 'krn_invstgcn'

	belongs_to :ownr, polymorphic: true

	belongs_to :krn_empresa_externa, optional: true
#	belongs_to :krn_investigador, optional: true

	has_many :act_archivos, as: :ownr, dependent: :destroy
	has_many :check_realizados, as: :ownr, dependent: :destroy
	has_many :check_auditorias, as: :ownr, dependent: :destroy
	has_many :audit_notas, as: :ownr, dependent: :destroy

	has_many :rep_archivos, as: :ownr, dependent: :destroy

	has_many :notas, as: :ownr, dependent: :destroy
	# Los ownr de los pdf_registros SIEMPRE son destinatarios
	has_many :pdf_registros, as: :ownr, dependent: :destroy

	has_many :krn_denunciantes, -> { order(created_at: :asc) }, dependent: :destroy
	has_many :krn_denunciados, -> { order(created_at: :asc) }, dependent: :destroy
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
	include Dnnc
	include DnncProc
	include Fls

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

	def prcdmnt
		Procedimiento.find_by(codigo: 'krn_invstgcn')
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

	# ------------------------------------------------------------------------ PRODUCTO
	def lttr_tp
		self.multiempresa? ? 'Multi' : (self.externa? ? 'Externa' : (self.empresa? ? 'Empresa' : '?'))
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

	# ------------------------------------------------------------------------ COMPETENCIA DE INVESTIGAR
	# Se conservó la forma inicial

	def empleados_externos?
		krn_denunciantes.exists?(empleado_externo: true) || krn_denunciados.exists?(empleado_externo: true)
	end

	def emprss_ids
		(krn_denunciantes.pluck(:krn_empresa_externa_id) + krn_denunciados.pluck(:krn_empresa_externa_id)).uniq
	end

	def empresa?
		not empleados_externos?
	end

	def externa?
		ids = emprss_ids
		empleados_externos? and
		ids.size == 1 and ids[0] != nil
	end

	# NO se usa
	def multiempresa?
		empleados_externos? and
		emprss_ids.size > 1
	end

	def externa_id
		rcp_externa? ? krn_empresa_externa_id : (externa? ? emprss_ids[0] : nil)
	end

	# externa que investiga REVISAR porque se puede confundir con Externa que recibió
	def empleador
		ids = self.emprss_ids
		self.externa? ? KrnEmpresaExterna.find(ids[0]) : nil
	end

	# ------------------------------------------------------------------------ RCPS & DRVS

	def rcp_empresa?
		receptor_denuncia == RECEPTORES[0]
	end

	def rcp_externa?
		receptor_denuncia == RECEPTORES[1]
	end

	def rcp_dt?
		receptor_denuncia == RECEPTORES[2]
	end

	def emprs_recibida_por_extrn?
		rcp_externa? and empresa?
	end

	def extrn_recibida_por_emprs?
		rcp_empresa? and externa?
	end

	def on_empresa?
		campo = krn_derivaciones.none? ?  receptor_denuncia : krn_derivaciones.last&.destino
		campo == RECEPTORES[0]
	end

	def on_externa?
		campo = krn_derivaciones.none? ?  receptor_denuncia : krn_derivaciones.last&.destino
		campo == RECEPTORES[1]
	end

	def on_dt?
		campo = krn_derivaciones.none? ?  receptor_denuncia : krn_derivaciones.last&.destino
		campo == RECEPTORES[2]
	end

	def drvcn_dt?
		krn_derivaciones.last&.destino == RECEPTORES[2]
	end

	# ------------------------------------------------------------------------ ESTADO DE LOS REEGISTROS BAJO DNNC

	def act_operativo?(cdg)
		act_archivos.exists?(act_archivo: cdg) ||
		CheckRealizado.objt_rlzd?(self, cdg)
	end

	# Se ingresó información mínima de la denuncia y sus participantes
	def prtcpnts_minimos?
		krn_denunciantes.exists? && (krn_denunciados.exists? || violencia?)
	end

	def on_rcp?
		prtcpnts_minimos? and krn_derivaciones.none?
	end

 	# No hay derivaciones entre empresas
 	def proc_not_drvcn_entre_empresas?
 		campos = [tsk_emprs_drvcn_extrn?, tsk_extrn_drvcn_emprs?]
 		campos.count(true) == 0
 	end

	# Se entregó la información obligatoria a los denunciantes
	def dnncnts_infrmds?
	    krn_denunciantes.all? do |denunciante|
	      denunciante.act_archivos.exists?(act_archivo: 'dnncnt_info_oblgtr') ||
	      denunciante.check_realizados.exists?(cdg: 'dnncnt_info_oblgtr')
	    end
	end

	def tiene_art4_1?
		krn_denunciantes.exists?(articulo_4_1: true) || krn_denunciados.exists?(articulo_4_1: true)
	end

	# todos tienen rut e email, considera caso de articulo_516 y violencia
	def cmplts?
	  return false if krn_denunciantes.none?

	  # Solo chequea denunciados si violencia? es falso
	  if !violencia? && krn_denunciados.none?
	    return false
	  end

	  krn_denunciantes.all?(&:cmplt?) &&
	  krn_denunciados.all?(&:cmplt?) &&
	  krn_denunciantes.flat_map(&:krn_testigos).all?(&:cmplt?) &&
	  krn_denunciados.flat_map(&:krn_testigos).all?(&:cmplt?)
	end

	def donde_estoy?
		on_empresa? ? RECEPTORES[0] : (on_externa? ? RECEPTORES[1] : RECEPTORES[2])
	end

	def not_on_dt?
		donde_estoy? != RECEPTORES[2]
	end

	def drvcn_with_cdg(cdg)
		krn_derivaciones.exists?(codigo: cdg)		
	end

	def apt_coordinada?
		ownr.coordinacion_apt ? act_operativo?('crdncn_apt') : true
	end

	def infrmcn_slctd?
		act_operativo?('infrmcn')
	end

	def comprobantes_firmados?
		krn_denunciantes.all?(&:tiene_comprobante?)
	end

	def tiene_mdds_rsgrd?
#	  act_archivos.any? { |a| a.act_archivo == 'mdds_rsgrd' && a.pdf.attached? }
	  act_archivos.any? { |a| a.act_archivo == 'mdds_rsgrd' }
	end

	def tienen_mdds_rsgrd?
		(krn_denunciantes + krn_denunciados).all?(&:tiene_mdds_rsgrd?)
	end

	def dnnc_notificada?
		krn_denunciantes.map {|d| d.act_operativo?('invstgcn').to_s}.uniq.join('_') == 'true'
	end

	def mdds_rsgrd?
		tiene_mdds_rsgrd? and tienen_mdds_rsgrd?
	end

	def evidencia_apt?
		krn_denunciantes.map {|d| d.act_operativo?('apt').to_s}.uniq.join('_') == 'true'
	end

	def dnnc?
		act_operativo?('denuncia')
	end

	def tiene_investigador?
		krn_inv_denuncias.where(objetado: [false, nil]).exists?
	end

	def analizada?
		evlcn_ok or (evlcn_incnsstnt and fecha_hora_corregida?)
	end

	def tienen_dclrcn?
	  return false if krn_denunciantes.none?

	  # Solo chequea denunciados si violencia? es falso
	  if !violencia? && krn_denunciados.none?
	    return false
	  end

	  krn_denunciantes.all?(&:tiene_dclrcn?) &&
	  krn_denunciados.all?(&:tiene_dclrcn?) &&
	  krn_denunciantes.flat_map(&:krn_testigos).all?(&:tiene_dclrcn?) &&
	  krn_denunciados.flat_map(&:krn_testigos).all?(&:tiene_dclrcn?)
	end

	def tiene_infrm?
	  act_archivos.any? { |a| a.act_archivo == 'informe' && a.pdf.attached? || a.rlzd? }
	end

	def tiene_mdds_sncns?
	  act_archivos.load.any? do |a|
	    a.act_archivo == 'medidas_sanciones' && (a.pdf.attached? || a.rlzd?)
	  end
	end
	
	def fecha_ultima_evidencia
		act_archivos&.where(act_archivo: 'medidas_sanciones')&.last.fecha
	end

	def unir_pdfs!
	  blobs = []

	  # 1.a → propios de la denuncia
	  blobs += act_archivos.with_attached_pdf.map { |aa| aa.pdf.blob }

	  # 1.b → de denunciantes y sus testigos
	  den_ids  = krn_denunciantes.pluck(:id)
	  tst_ids  = krn_denunciantes.joins(:krn_testigos).pluck('krn_testigos.id')
	  blobs += ActArchivo
	             .with_attached_pdf
	             .where(ownr_type: 'KrnDenunciante', ownr_id: den_ids)
	             .or(
	               ActArchivo.with_attached_pdf
	                         .where(ownr_type: 'KrnTestigo', ownr_id: tst_ids)
	             )
	             .map { |aa| aa.pdf.blob }

	  # 1.c → de denunciados y sus testigos
	  den_ids2 = krn_denunciados.pluck(:id)
	  tst_ids2 = krn_denunciados.joins(:krn_testigos).pluck('krn_testigos.id')
	  blobs += ActArchivo
	             .with_attached_pdf
	             .where(ownr_type: 'KrnDenunciado', ownr_id: den_ids2)
	             .or(
	               ActArchivo.with_attached_pdf
	                         .where(ownr_type: 'KrnTestigo', ownr_id: tst_ids2)
	             )
	             .map { |aa| aa.pdf.blob }

	  blobs.compact!
	  return if blobs.empty?

	  # 2. combinar … (resto idéntico)
	  combined = CombinePDF.new
	  blobs.each { |b| combined << CombinePDF.parse(b.download) }

	  nuevo = act_archivos.new(
	    mdl:         'ClssPrcdmnt',
	    act_archivo: 'combinado',
	    nombre:      "pdf_#{id}_combinado.pdf"
	  )
	  nuevo.pdf.attach(
	    io:           StringIO.new(combined.to_pdf),
	    filename:     "denuncia_#{id}_combinado.pdf",
	    content_type: 'application/pdf'
	  )
	  nuevo.save!
	  nuevo
	end

	private
	
	def licencia_valida
		lic = ownr.licencia_actual
		errors.add(:base, 'No tienes licencia activa')               and return unless lic
		errors.add(:base, 'Licencia expirada')                       and return if lic.expirada?
		errors.add(:base, 'Has alcanzado el límite de denuncias')    and return if lic.tope_alcanzado?
	end

end
