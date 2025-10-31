# app/controllers/act_textos_controller.rb
class Repositorios::ActTextosController < ApplicationController
  before_action :set_act_texto
  before_action :set_act_archivo

  def show
    @act_texto = @act_archivo.act_textos.find(params[:id])
  end

  def edit
    @act_texto = @act_archivo.act_textos.find(params[:id])
  end

  def update
    @act_texto = @act_archivo.act_textos.find(params[:id])
    
    if @act_texto.update(act_texto_params)
      redirect_to act_archivo_act_texto_path(@act_archivo, @act_texto), 
                  notice: 'Documento actualizado correctamente.'
    else
      render :edit
    end
  end

  def exportar
    @act_texto = @act_archivo.act_textos.find(params[:id])
    formato = params[:formato]
    
    case formato
    when 'pdf'
      @act_texto.exportar_a_pdf!
      archivo = @act_texto.archivo_exportado
    when 'word'
      @act_texto.exportar_a_word!
      archivo = @act_texto.archivo_exportado
    end

    if archivo.attached?
      redirect_to rails_blob_url(archivo, disposition: "attachment")
    else
      redirect_to act_archivo_act_texto_path(@act_archivo, @act_texto), 
                  alert: "Error al generar el archivo."
    end
  end

  private

  def set_act_texto
    @act_texto = ActTexto.find(params[:id])
  end

  def set_act_archivo
    @act_archivo = ActArchivo.find(params[:act_archivo_id])
  end

  def act_texto_params
    params.require(:act_texto).permit(:titulo, :contenido, :notas)
  end
end