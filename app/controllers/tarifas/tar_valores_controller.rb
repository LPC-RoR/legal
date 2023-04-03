class Tarifas::TarValoresController < ApplicationController
  before_action :set_tar_valor, only: %i[ show edit update destroy ]

  # GET /tar_valores or /tar_valores.json
  def index
  end

  # GET /tar_valores/1 or /tar_valores/1.json
  def show
  end

  # GET /tar_valores/new
  def new
    @objeto = TarValor.new(owner_class: params[:class_name], owner_id: params[:objeto_id])
  end

  # GET /tar_valores/1/edit
  def edit
  end

  # POST /tar_valores or /tar_valores.json
  def create
    @objeto = TarValor.new(tar_valor_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar valor was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_valores/1 or /tar_valores/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_valor_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar valor was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_valores/1 or /tar_valores/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tar valor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_valor
      @objeto = TarValor.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/#{@objeto.padre.class.name.downcase.pluralize}/#{@objeto.padre.id}?html_options[menu]=Facturacion"
    end

    # Only allow a list of trusted parameters through.
    def tar_valor_params
      params.require(:tar_valor).permit(:codigo, :detalle, :valor_uf, :valor, :owner_class, :owner_id)
    end
end
