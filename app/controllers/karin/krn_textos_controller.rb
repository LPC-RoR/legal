class Karin::KrnTextosController < ApplicationController
  before_action :set_krn_texto, only: [:show, :edit, :update, :destroy, :resumir, :anonimizar, :confirmar_hechos]
  before_action :set_ownr

  def show
    
  end

  def new
    cdg = 
    @objeto   = @ownr.krn_textos.build(codigo: params[:cdg])
    @cdgs_list = ClssPdfRprt.txt_lst[params[:cdg].to_sym]
  end

  def create
    @objeto = @ownr.krn_textos.build(krn_texto_params)
    
    if @objeto.save
      redirect_to default_redirect_path(@objeto), notice: 'Texto creado correctamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    cdg_list    = ClssPdfRprt.sym_from_cdg(@objeto.ownr, @objeto.codigo)
    @cdgs_list  = ClssPdfRprt.txt_lst[cdg_list]
  end

  def update
    if @objeto.update(krn_texto_params)
      redirect_to default_redirect_path(@objeto), notice: 'Texto actualizado correctamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def resumir
    dnnc = @objeto.ownr.dnnc
    nombres = dnnc.hash_nombres_anonimizacion

    GenerarResumenKrnTextoJob.perform_later(@objeto.id, nombres)

    redirect_to dnnc_path(@objeto.ownr.dnnc, 2), notice: "El resumen cronológico se está generando."
  end

  def anonimizar
    dnnc = @objeto.ownr.dnnc
    nombres = dnnc.hash_nombres_anonimizacion

    AnonimizarKrnTextoJob.perform_later(@objeto.id, nombres)

    redirect_to dnnc_path(@objeto.ownr.dnnc, 2), notice: "El texto anonimizado se está generando."
  end

  def confirmar_hechos
    dnnc = @objeto.ownr.dnnc
    nombres = dnnc.hash_nombres_anonimizacion
    # El ActArchivo de la denuncia viene como parámetro
    act_archivo_denuncia = dnnc.act_archivos.find_by(act_archivo: 'denuncia')
    nombres_denunciantes = dnnc.krn_denunciantes.map { |d| d.nombre || d.nombre }.compact
    nombres_denunciados  = dnnc.krn_denunciados.map  { |d| d.nombre || d.nombre }.compact

    # Hash completo de anonimización
    nombres = {}
    nombres_denunciantes.each_with_index { |n, i| nombres[n] = "Denunciante #{i + 1}" }
    nombres_denunciados.each_with_index  { |n, i| nombres[n] = "Denunciado #{i + 1}" }

    tipo = @objeto.ownr.kywrd[:rol]

    ConfirmarHechosJob.perform_later(
      @objeto.id,
      act_archivo_denuncia.id,
      nombres_anonimizar: nombres,
      tipo_declarante: tipo,
      nombres_denunciantes: nombres_denunciantes,
      nombres_denunciados: nombres_denunciados
    )

    redirect_to dnnc_path(@objeto.ownr.dnnc, 2), notice: "El reporte de confirmación de hechos se está generando."
  rescue ActiveRecord::RecordNotFound
    redirect_to dnnc_path(@objeto.ownr.dnnc, 2), alert: "No se encontró el archivo de denuncia especificado."
  end

  def destroy
    @objeto.destroy
    redirect_to default_redirect_path(@objeto), notice: 'Texto eliminado.'
  end

  private

  def set_ownr
    if params[:oclss].present? && params[:oid].present?
      @ownr = params[:oclss].constantize.find(params[:oid])
    elsif params[:krn_texto].present? && params[:krn_texto][:ownr_type].present?
      @ownr = params[:krn_texto][:ownr_type].constantize.find(params[:krn_texto][:ownr_id])
    elsif @objeto.present?
      @ownr = @objeto.ownr
    else
      redirect_to root_path, alert: 'No se pudo determinar el propietario.'
    end
  end

  def set_krn_texto
    # Para edit/update/destroy, busca directamente por ID
    # (no necesita @ownr porque se ejecuta antes)
    if params[:id].present?
      @objeto = KrnTexto.find(params[:id])
    end
  end

  def krn_texto_params
    params.require(:krn_texto).permit(:codigo, :titulo, :contenido, :ownr_type, :ownr_id)
  end
end