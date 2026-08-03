# app/controllers/concerns/pdf_combinable.rb
module PdfCombinable
  extend ActiveSupport::Concern

  def combinar_pdf
    ownr = @objeto
    code = params[:code]

    cmbnd_clss = ClssCmbnd.context_class(code)
    blobs      = cmbnd_clss.ownr_blobs_for(ownr, code)

    blobs.compact!
    return redirect_back(fallback_location: root_path, alert: "No hay PDFs para combinar") if blobs.empty?

    # 1. Combinar PDFs
    combined = CombinePDF.new
    blobs.each { |b| combined << CombinePDF.parse(b.download) }

    # 2. Generar filename asegurando extensión .pdf
    base_name = cmbnd_clss.filename(ownr, code).to_s.sub(/\.pdf$/i, "")
    filename  = "#{base_name}.pdf"

    # 3. Crear el registro PRIMERO (sin PDF) para tener un ID persisted
    nuevo = ownr.act_archivos.create!(
      mdl:         cmbnd_clss,
      act_archivo: code,
      nombre:      cmbnd_clss.nombre[code]
    )

    # 4. Adjuntar el PDF combinado
    nuevo.pdf.attach(
      io:           StringIO.new(combined.to_pdf),
      filename:     filename,
      content_type: "application/pdf"
    )

    redirect_to rdrct_path(ownr, code)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "[PdfCombinable] Error creando ActArchivo: #{e.message}"
    redirect_back(fallback_location: root_path, alert: "Error al generar el PDF combinado: #{e.message}")
  end

  private

  def rdrct_path(ownr, code)
    # CORREGIDO: era 'objt', ahora 'ownr'
    shw_dnnc_tab_indx(ownr, 4)
  end
end