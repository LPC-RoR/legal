class HechoDocsController < ApplicationController
  before_action :set_hecho_doc, only: %i[ cambia_tag ]

  def cambia_tag
    case @objeto.establece
    when 'confirma'
      @objeto.establece = 'desmiente'
    when 'desmiente'
      @objeto.establece = 'desestima'
    else
      @objeto.establece = 'confirma'
    end
    @objeto.save
    
    redirect_to "/causas/#{@objeto.hecho.tema.causa.id}?html_options[menu]=Hechos"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hecho_doc
      @objeto = HechoDoc.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hecho_doc_params
      params.require(:hecho_doc).permit(:hecho_id, :app_documento_id, :establece)
    end
end
