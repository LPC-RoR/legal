class Cliente < ApplicationRecord
	# Manejo de logos
	include Brandeable
    include RutNormalizable
  	include AASM

	TIPOS = ['Empresa', 'Sindicato', 'Trabajador']

    has_one :tenant, as: :owner, dependent: :destroy
	has_many :usuarios, through: :tenant
#    after_create :crear_tenant

	# tabla de CLIENTES
	# 1.- Evaluar has_many tar_facturas

	has_many :app_nominas, as: :ownr

	has_many :causas
	has_many :asesorias
	has_many :cargos

	has_many :tar_tarifas, as: :ownr
	has_many :tar_servicios, as: :ownr
	# DEPRECATED
	has_many :tar_aprobaciones

	has_many :tar_facturaciones, through: :causas

	has_many :doc_emitidos
	has_many :doc_transacciones, as: :relacionable

	has_many :age_actividades, as: :ownr

	# Manejo de logos y footer
	has_one_attached :logo
	has_rich_text :email_footer

	# Se agregó para relacionar pdfs de aprobaciones, después se cambió a cli_aprobaciones
	has_many :act_archivos, as: :ownr, dependent: :destroy

	has_many :app_contactos, as: :ownr
	has_many :app_archivos, as: :ownr
	has_many :notas, as: :ownr

	has_many :cli_aprobaciones, dependent: :destroy

    validates_presence_of :rut, :razon_social, :tipo_cliente

    scope :std, ->(estado) { where(estado: estado)}
    scope :typ, ->(tipo) { where(estado: 'activo', tipo_cliente: tipo) }

    scope :cl_ordr, -> { order(preferente: :desc, razon_social: :asc) }

	# Método para obtener todas las tar_facturaciones pendientes de aprobación del cliente
	def tar_facturaciones_pendientes_aprobacion
		# Obtener IDs de TarCalculo que pertenecen a las causas del cliente
		tar_calculo_ids = causas.joins(:tar_calculos).pluck('tar_calculos.id')

		# Obtener IDs de Asesoria que pertenecen al cliente
		asesoria_ids = asesorias.pluck(:id)

		# Buscar todas las TarFacturacion donde ownr sea cualquiera de esos registros
		# y que no tengan cli_aprobacion_id
		TarFacturacion.where(
		  "(ownr_type = 'TarCalculo' AND ownr_id IN (?)) OR (ownr_type = 'Asesoria' AND ownr_id IN (?))",
		  tar_calculo_ids,
		  asesoria_ids
		).where(cli_aprobacion_id: nil, tar_aprobacion_id: nil, facturado: [nil, false])
	end

    # ---------------------------------------------------------------- ESTADOS con AASM

	# Proceso Operativo
	aasm(:comercial, column: 'estado') do
		state :activo, initial: true
		state :inactivo

		event :up_to_inactivo do
		  transitions from: :activo, to: :inactivo
		end

		event :dwn_to_activo do
		  transitions from: :inactivo, to: :activo
		end
	end

	def evento_permitido?(proceso, evento)
	  # Método 100% funcional (verificado en consola)
	  aasm(proceso.to_sym).may_fire_event?(evento.to_sym)
	rescue StandardError => e
	  Rails.logger.error "🔴 Error verificando evento: #{e.message}"
	  false
	end

	def ejecutar_evento(proceso, evento)
	  # Verificación segura
	  unless evento_permitido?(proceso, evento)
	    raise ArgumentError, "Evento '#{evento}' no permitido desde estado '#{send("estado_#{proceso}")}'"
	  end

	  # Ejecutar con AASM API nativa
	  aasm(proceso.to_sym).fire!(evento.to_sym)
	end
    # ---------------------------------------------------------------- ESTADOS con AASM (FIN)

    # ---------------------------------------------------------------- CliAprobacion

	def crear_aprobacion(fecha: Date.current)
		cli_aprobaciones.create!(fecha: fecha)
	end

	def facturaciones_pendientes
		causas_ids = causas.pluck(:id)
		calculos_ids = TarCalculo.where(ownr_type: 'Causa', ownr_id: causas_ids).pluck(:id)

		TarFacturacion.where(cli_aprobacion_id: nil, tar_calculo_id: calculos_ids)
	end

	# OBJETO

    def st_modelo
    	StModelo.find_by(st_modelo: self.class.name)
    end

	def enlaces
		AppEnlace.where(owner_class: self.class.name, owner_id: self.id)
	end

	# ----------------------------------------------------
	# DEPRECATED : Se sacó control de archivos desde el despliegue del registro
	# Hay que borrar registros asociados si es que los hay
	# Luego borrar métodos verificando previamente su uso

	# Archivos y control de archivos

	# Nombres de los archivos
	def nms
		self.app_archivos.nms.union(self.documentos.nms)
	end

	def fnd_fl(app_archivo)
		self.app_archivos.find_by(app_archivo: app_archivo)
	end

	def acs
		self.st_modelo.acs
	end

	# Archivos NO Controlados
	def as
		self.app_archivos.where.not(app_archivo: self.acs.nms)
	end

	def dcs
		self.st_modelo.dcs
	end

	def nombres_usados
		self.archivos.map {|archivo| archivo.app_archivo}
	end

	def archivos
		AppArchivo.where(owner_class: 'Cliente', owner_id: self.id)
	end

	def archivos_controlados
		self.st_modelo.control_documentos.where(tipo: 'Archivo').order(:nombre)
	end

	def archivos_pendientes
		ids = self.archivos_controlados.map {|control| control.id unless self.nombres_usados.include?(control.nombre) }.compact
		ControlDocumento.where(id: ids)
	end

	def archivos_faltantes
		self.archivos_pendientes.where(control: 'Requerido')
	end

	def archivos_vacios
		nombres_controlados = self.archivos_controlados.where(control: 'Requerido').map {|ac| ac.nombre}
		self.archivos.where(app_archivo: nombres_controlados, archivo: nil)
	end
	# ------------------------------------------------------------

	def aprobaciones
		self.facturaciones.where(estado: 'aprobación').order(created_at: :desc)
	end

	def facturaciones_pendientes
		self.facturaciones.where(estado: 'aprobado', tar_factura_id: nil)
	end

	def uf_dia
		uf = TarUfSistema.find_by(fecha: Time.zone.today.to_date)
		uf.blank? ? 0 : uf.valor
	end

	# Manejo de logos y footer

	def footer_content
		email_footer
	end

	def brand_name
		razon_social
	end

end
