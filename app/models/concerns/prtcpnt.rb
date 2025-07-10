module Prtcpnt
  extend ActiveSupport::Concern

  # Métodos de instancia
  included do
    def empleador_ok?
      self.empleado_externo ? self.krn_empresa_externa.present? : true
    end

    def direccion_ok?
      self.articulo_516 ? self.direccion_notificacion.present? : self.email.present?
    end

  	def rgstr_ok?
  		self.empleador_ok? and self.direccion_ok? and self.rut? and ( self.class.name == 'KrnTestigo' ? true : self.krn_testigos.rgstrs_ok?)
  	end

    def dnnc
      self.class.name == 'KrnTestigo' ? self.ownr.krn_denuncia : self.krn_denuncia
    end

    def empleador
      self.empleado_externo ? (self.krn_empresa_externa.present? ? self.krn_empresa_externa.razon_social : 'Pendiente de ingreso') : 'Empleado de la empresa'
    end

  	def dflt_bck_rdrccn
  		"/krn_denuncias/#{self.dnnc.id}_1"
  	end

  	# En cada modelo (KrnDenunciante, KrnInvestigador, etc.)
  	def verified?
  	  verification_sent_at.present?
  	end

    def dclrcn?
      self.fl?('prtcpnts_dclrcn') and (self.class.name == 'KrnTestigo' ? true : self.krn_testigos.dclrcns?)
    end

  end

  # Métodos de clase
  class_methods do
    def rgstrs_ok?
      all.empty? ? (name == 'KrnTestigo' ? true : false) : all.map {|den| den.rgstr_ok?}.uniq.join('-') == 'true'
    end

    def emprss_ids
      name == 'KrnTestigo' ? nil : all.map {|den| den.krn_empresa_externa_id if !!den.empleado_externo}.uniq
    end

    def dclrcns?
      all.empty? ? (name == 'KrnTestigo' ? true : false) : all.map {|objt| objt.dclrcn?}.uniq.join('-') == 'true'
    end

  end
end