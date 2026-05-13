module ActsChecks
	extend ActiveSupport::Concern

	# **************************************** Subido o realizado

	def file_or_check?(code)
    act_archivos.exists?(act_archivo: code) ||
    act_referencias.exists?(code: code) ||
    check_realizados.exists?(cdg: code)
	end

	# **************************************** Acceso a los PDF 

  def pdf_para(codigo)
    # Primero busca en ActArchivo
    archivo = act_archivos.find_by(act_archivo: codigo)
    return archivo.pdf if archivo&.pdf.present?

    # Si no hay, busca en CheckRealizado
    check = check_realizados.find_by(code: codigo)
    check&.pdf
  end

	def todos_los_pdfs_para(codigo)
	  archivos = act_archivos.where(act_archivo: codigo).where.not(pdf: nil)
	  checks = check_realizados.where(code: codigo).where.not(pdf: nil)

	  {
	    generados: archivos.map(&:pdf),
	    terceros: checks.map(&:pdf),
	    todos: archivos.map(&:pdf) + checks.map(&:pdf)
	  }
	end

	def cmbnds_blobs
	  	blobs = []
	  	acts 	= act_archivos.with_attached_pdf
	  	chks  	= check_realizados.with_attached_pdf
		self.class::CMBND_PDF_LST.each do |code|
			act_lst = acts.where(act_archivo: code)
			chk_lst = chks.where(cdg: code)
			if act_lst.any?
				blobs += act_lst.map {|act| act.pdf.blob unless !!act.excluir}
			end
			if chk_lst.any?
				blobs += chk_lst.map {|chk| chk.pdf.blob unless !!chk.excluir}
			end
		end
		blobs.compact
	end

	def ntfccns_blobs
		ntfccns_lst = ['dnncnt_info_oblgtr', 'comprobante', 'invstgcn', 'drchs', 'txt_mdds_rsgrd', 'drvcn', 'invstgdr', 'dclrcn'].freeze
  	blobs = []
  	acts 	= act_archivos.with_attached_pdf
  	chks  = check_realizados.with_attached_pdf

  	refs = act_referencias

		ntfccns_lst.each do |code|
			act_lst = acts.where(act_archivo: code)
			chk_lst = chks.where(cdg: code)
			ref_lst = refs.where(code: code)
			if act_lst.any?
				blobs += act_lst.map {|act| act.pdf.blob unless !!act.excluir}
			end
			if chk_lst.any?
				blobs += chk_lst.map {|chk| chk.pdf.blob unless !!chk.excluir}
			end
			if ref_lst.any?
				blobs += ref_lst.map {|ref| ref&.act_archivo&.pdf&.blob unless !!chk&.act_archivo&.excluir}
			end
		end
		blobs.compact
	end

	def unir_pdfs!
		# with_attached_pdf es un scope de ActArchivo

		blobs = cmbnds_blobs
#		blobs = cmbnds_blobs || []

		if self.class.name == 'KrnDenuncia'
			krn_denunciantes.each do |dnncnt|
				blobs += dnncnt.cmbnds_blobs
			end

			krn_denunciados.each do |dnncd|
				blobs += dnncd.cmbnds_blobs
			end

			krn_testigos.each do |tstg|
				blobs += tstg.cmbnds_blobs
			end
		end

	 	blobs.compact!
		return if blobs.empty?

	  # 2. combinar … (resto idéntico)
	  combined = CombinePDF.new
	  blobs.each { |b| combined << CombinePDF.parse(b.download) }

	  nuevo = act_archivos.new(
	    mdl:         'ClssPrcdmnt',
	    act_archivo: 'combinado',
	    nombre:      "#{kywrd[:rol]}_#{id}_combinado.pdf"
	  )
	  nuevo.pdf.attach(
	    io:           StringIO.new(combined.to_pdf),
	    filename:     "#{kywrd[:rol]}_#{id}_combinado.pdf",
	    content_type: 'application/pdf'
	  )
	  nuevo.save!
	  nuevo
	end

	def generar_dsgncn!

		inv = krn_inv_denuncias&.last
		dsgncn = inv&.act_referencias&.find_by(code: 'txt_dsgncn')&.act_archivo
		titulo = inv&.krn_investigador&.act_archivos.find_by(act_archivo: 'titulo_prfsnl')

		if dsgncn && titulo
			blobs = [dsgncn.pdf.blob, titulo.pdf.blob]

		 	blobs.compact!
			return if blobs.empty?

		  combined = CombinePDF.new
		  blobs.each { |b| combined << CombinePDF.parse(b.download) }

		  nuevo = act_archivos.new(
		    mdl:         'ClssPrcdmnt',
		    act_archivo: 'dsgncn_invstgdr',
		    nombre:      "Designación del investigador"
		  )
		  nuevo.pdf.attach(
		    io:           StringIO.new(combined.to_pdf),
		    filename:     "designacion_investigador.pdf",
		    content_type: 'application/pdf'
		  )
		  nuevo.save!
		  nuevo
		end
	end

	def generar_ntfccns!
  	blobs = []

		if self.class.name == 'KrnDenuncia'
			krn_denunciantes.each do |dnncnt|
				blobs += dnncnt.ntfccns_blobs
			end

			krn_denunciados.each do |dnncd|
				blobs += dnncd.ntfccns_blobs
			end

			krn_testigos.each do |tstg|
				blobs += tstg.ntfccns_blobs
			end
		end

		blobs.compact
		return if blobs.empty?

	  # 2. combinar … (resto idéntico)
	  combined = CombinePDF.new
	  blobs.each { |b| combined << CombinePDF.parse(b.download) }

	  nuevo = act_archivos.new(
	    mdl:         'ClssPrcdmnt',
	    act_archivo: 'ntfccns',
	    nombre:      "Notificaciones de la denuncia"
	  )
	  nuevo.pdf.attach(
	    io:           StringIO.new(combined.to_pdf),
	    filename:     "notificaciones.pdf",
	    content_type: 'application/pdf'
	  )
	  nuevo.save!
	  nuevo
		
	end

	def generar_dclrcns!
  	blobs = []

		if self.class.name == 'KrnDenuncia'
			krn_denunciantes.each do |dnncnt|
				act = dnncnt.act_archivos.find_by(act_archivo: 'declaracion')
				blobs += [act.pdf.blob] if act
			end

			krn_denunciados.each do |dnncd|
				act = dnncd.act_archivos.find_by(act_archivo: 'declaracion')
				blobs += [act.pdf.blob] if act
			end

			krn_testigos.each do |tstg|
				act = tstg.act_archivos.find_by(act_archivo: 'declaracion')
				blobs += [act.pdf.blob] if act
			end
		end

		blobs.compact
		return if blobs.empty?

	  # 2. combinar … (resto idéntico)
	  combined = CombinePDF.new
	  blobs.each { |b| combined << CombinePDF.parse(b.download) }

	  nuevo = act_archivos.new(
	    mdl:         'ClssPrcdmnt',
	    act_archivo: 'dclrcns',
	    nombre:      "Declaraciones de la denuncia"
	  )
	  nuevo.pdf.attach(
	    io:           StringIO.new(combined.to_pdf),
	    filename:     "declaraciones.pdf",
	    content_type: 'application/pdf'
	  )
	  nuevo.save!
	  nuevo

	end

end