# app/controllers/krn_textos_controller.rb
class Karin::KrnTextosController < ApplicationController
  before_action :set_ownr
  before_action :set_krn_texto, only: [:edit, :update, :destroy]

  def new
    @objeto = @ownr.krn_textos.build(codigo: params[:cdg])
  end

  def create
    @objeto = @krn_denuncia.krn_textos.build(krn_texto_params)
    
    if @objeto.save
      redirect_to @krn_denuncia, notice: 'Texto creado correctamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @objeto.update(krn_texto_params)
      redirect_to @krn_denuncia, notice: 'Texto actualizado correctamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @objeto.destroy
    redirect_to @krn_denuncia, notice: 'Texto eliminado.'
  end

  private

  def set_ownr
    @ownr = params[:oclss].constantize.find(params[:oid])
  end

  def set_krn_texto
    @objeto = @krn_denuncia.krn_textos.find(params[:id])
  end

  def krn_texto_params
    params.require(:krn_texto).permit(:codigo, :titulo, :contenido)
  end
end