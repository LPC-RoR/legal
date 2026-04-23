class Karin::KrnTextosController < ApplicationController
  before_action :set_krn_texto, only: [:show, :edit, :update, :destroy]
  before_action :set_ownr

  def show
    
  end

  def new
    @objeto = @ownr.krn_textos.build(codigo: params[:cdg])
    puts "************************************ flag"
    puts @ownr.class.name
    puts @ownr.id
    puts "************************************ flag"
    @cdgs_list = ClssPdfRprt.txt_list[@ownr.kywrd[:sym]]
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
    @cdgs_list = ClssPdfRprt.txt_list[@ownr.kywrd[:sym]]
  end

  def update
    if @objeto.update(krn_texto_params)
      redirect_to default_redirect_path(@objeto), notice: 'Texto actualizado correctamente.'
    else
      render :edit, status: :unprocessable_entity
    end
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