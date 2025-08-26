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

    def email_vrfcd?
      self.articulo_516 ? true : (self.verified? and (self.email == self.email_ok))
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

    # --------------------------------- PDF Archivos y registros
    def get_pdf_registro(code)
      pdf = PdfArchivo.find_by(codigo: code)
      pdf.blank? ? nil : self.pdf_registros.find_by(pdf_archivo_id: pdf.id)
    end

    def drchs_sent?
      pdf = PdfArchivo.find_by(codigo: 'drchs')
      pdf.blank? ? nil : self.pdf_registros.find_by(pdf_archivo_id: pdf.id).present?
    end

    def invstgcn_sent?
      pdf = PdfArchivo.find_by(codigo: 'invstgcn')
      frst = pdf.blank? ? nil : self.pdf_registros.find_by(pdf_archivo_id: pdf.id).present? and (self.class.name == 'KrnTestigo' ? true : self.krn_testigos.invstgcn_sents?)
    end

    def mdds_rsgrd_sent?
      pdf = PdfArchivo.find_by(codigo: 'mdds_rsgrd')
      pdf.blank? ? nil : self.pdf_registros.find_by(pdf_archivo_id: pdf.id).present? and (self.class.name == 'KrnTestigo' ? true : self.krn_testigos.mdds_rsgrd_sents?)
    end

    def dclrcn?
      self.fl?('prtcpnts_dclrcn') and (self.class.name == 'KrnTestigo' ? true : self.krn_testigos.dclrcns?)
    end

    def invstgdr_sent?
      pdf = PdfArchivo.find_by(codigo: 'invstgdr')
      frst = pdf.blank? ? nil : self.pdf_registros.find_by(pdf_archivo_id: pdf.id).present? and (self.class.name == 'KrnTestigo' ? true : self.krn_testigos.invstgdr_sents?)
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

    def dclrcns?
      all.empty? ? (name == 'KrnTestigo' ? true : false) : all.map {|objt| objt.dclrcn?}.uniq.join('-') == 'true'
    end

    def invstgcn_sents?
      all.empty? ? (name == 'KrnTestigo' ? true : false) : all.map {|objt| objt.invstgcn_sent?}.uniq.join('-') == 'true'
    end

    def mdds_rsgrd_sents?
      all.empty? ? (name == 'KrnTestigo' ? true : false) : all.map {|objt| objt.mdds_rsgrd_sent?}.uniq.join('-') == 'true'
    end

    def invstgdr_sents?
      all.empty? ? (name == 'KrnTestigo' ? true : false) : all.map {|objt| objt.invstgdr_sent?}.uniq.join('-') == 'true'
    end

  end
end