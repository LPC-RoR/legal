module ActsChecks
	extend ActiveSupport::Concern

	# **************************************** Subido o realizado

	def file_or_check?(code)
    act_archivos.exists?(act_archivo: code) ||
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

end