class Rprts::KrnReportesController < ApplicationController

  layout :pdf

  include Karin
  include ProcControl

  def dnnc
    @objeto = KrnDenuncia.find(params[:oid])

    load_objt(@objeto)
    load_proc(@objeto)

    set_tabla('krn_denunciantes', @objeto.krn_denunciantes.rut_ordr, false)
    set_tabla('krn_denunciados', @objeto.krn_denunciados.rut_ordr, false)
    set_tabla('krn_derivaciones', @objeto.krn_derivaciones.ordr, false)
    set_tabla('krn_inv_denuncias', @objeto.krn_inv_denuncias.order(:created_at), false)

    respond_to do |format|
      format.pdf do
        render pdf: "documento",
          margin: { top: '.5cm', bottom: '1cm', left: '1cm', right: '1cm' },
          page_size: 'A4',
          disable_smart_shrinking: true, # Importante para respetar dimensiones
          encoding: 'UTF-8',
             template: 'rprts/krn_reportes/dnnc',
             layout: 'pdf',
             show_as_html: params[:debug].present?,
             footer: { center: "Página [page] de [topage]" }
      end
    end
  end

  private

end
