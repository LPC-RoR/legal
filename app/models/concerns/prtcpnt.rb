module Prtcpnt
  extend ActiveSupport::Concern

  # Métodos de instancia
  included do

    # ********************************************** Métodos para before and after actions

    # Se utiliza para garantizar la consistencia entre krn_empresa_externa_id y empleado_externo
    def limpiar_empresa_externa
      self.krn_empresa_externa_id = nil unless empleado_externo?
    end

    # ********************************************** Labels

    def cnfdntl_key
      "[CONFIDENCIAL: #{sym.to_s.upcase}-#{id}]"
    end

    def cnfdntl_email
      "[CONFIDENCIAL: EMAIL-#{sym.to_s.upcase}-#{id}]"
    end

    def email_verificado?
      verified? and (email == email_ok)
    end

    def email_direccion?
      (articulo_516 and direccion_notificacion?) or email_verificado?
    end

    # ----------------------------------------------------------------- FUTURO DEPRECATED

    # Revisar porque tener articulo 516 no es tener el email verificado
    def email_vrfcd?
      self.articulo_516 ? true : (self.verified? and (self.email == self.email_ok))
    end

    # Este método debe funcionar para todos los modelos
    # RUT  e email/dirección
    # No se incluye caso de violencia, porque no se puede preguntar desde un registro que no existe
    def cmplt?
      rut? and email_direccion?
    end

  	def rgstr_ok?
  		self.rut? and ( self.class.name == 'KrnTestigo' ? true : self.krn_testigos.rgstrs_ok?)
  	end

    def dnnc
      self.class.name == 'KrnTestigo' ? self.ownr.krn_denuncia : self.krn_denuncia
    end

  	def dflt_bck_rdrccn
  		"/krn_denuncias/#{self.dnnc.id}_1"
  	end

  	# En cada modelo (KrnDenunciante, KrnInvestigador, etc.)
  	def verified?
  	  verification_sent_at.present?
  	end

    # --------------------------------- PDF Archivos y registros

    def tiene_dclrcn?
      file_or_check?('declaracion')
    end

  end

  # Métodos de clase
  class_methods do
    def rgstrs_ok?
      all.empty? ? (name == 'KrnTestigo' ? true : false) : all.map {|den| den.rgstr_ok?}.uniq.join('-') == 'true'
    end

    def emails_ok?
      all.empty? ? (name == 'KrnTestigo' ? true : false) : all.map {|den| den.email_vrfcd?}.uniq.join('-') == 'true'
    end

    def emprss_ids
      name == 'KrnTestigo' ? nil : all.map {|den| den.krn_empresa_externa_id if !!den.empleado_externo}.uniq
    end


  end
end