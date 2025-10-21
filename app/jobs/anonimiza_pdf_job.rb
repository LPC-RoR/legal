# app/jobs/anonimiza_pdf_job.rb
class AnonimizaPdfJob < ApplicationJob
  queue_as :default
  retry_on Faraday::TimeoutError, wait: :exponentially_longer, attempts: 5

  def perform(original_id, original_blob_id)
    original = ActArchivo.find(original_id)   # ← sin namespace
    blob     = ActiveStorage::Blob.find(original_blob_id)

    io = PdfAnonimizador.new(blob).anonimizado_io

    annmzd = ActArchivo.new(
      act_archivo:       "anonimizado",           # o el que quieras
      anonimizado:       true,
      anonimizado_de:    original
#      pdf:               original.pdf.blob        # ¡misma copia física!
    )
    annmzd.skip_pdf_presence = true   # ← salta la validación
    annmzd.save!

#  nuevo_act = denuncia.act_archivos.new(act_archivo: 'anonimizado')
#  nuevo_act.skip_pdf_presence = true   # ← salta la validación
#  nuevo_act.save!

    annmzd.pdf.attach(
      io: io,
      filename: "act_#{original.id}_anonimizada.pdf",
      content_type: 'application/pdf'
    )

  end
end