class Tarifas::TarVariableBasesController < ApplicationController
  before_action :set_tar_variable_bas, only: %i[ show edit update destroy ]

  # GET /tar_variable_bases or /tar_variable_bases.json
  def index
    @coleccion = TarVariableBase.all
  end

  # GET /tar_variable_bases/1 or /tar_variable_bases/1.json
  def show
  end

  # GET /tar_variable_bases/new
  def new
    @objeto = TarVariableBase.new(tar_tarifa_id: params[:tid])
  end

  # GET /tar_variable_bases/1/edit
  def edit
  end

  # POST /tar_variable_bases or /tar_variable_bases.json
  def create
    @objeto = TarVariableBase.new(tar_variable_bas_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar variable base was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_variable_bases/1 or /tar_variable_bases/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_variable_bas_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar variable base was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_variable_bases/1 or /tar_variable_bases/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tar variable base was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_variable_bas
      @objeto = TarVariableBase.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.tar_tarifa
    end

    # Only allow a list of trusted parameters through.
    def tar_variable_bas_params
      params.require(:tar_variable_base).permit(:tar_tarifa_id, :tipo_causa_id, :tar_base_variable)
    end
end
