class Tarifas::TarBasesController < ApplicationController
  before_action :set_tar_bas, only: %i[ show edit update destroy ]

  # GET /tar_bases or /tar_bases.json
  def index
#    @coleccion = {}
#    @coleccion['tar_bases'] = TarBase.all
    set_tabla('tar_bases', TarBase.all, false)
  end

  # GET /tar_bases/1 or /tar_bases/1.json
  def show
  end

  # GET /tar_bases/new
  def new
    @objeto = TarBase.new
  end

  # GET /tar_bases/1/edit
  def edit
  end

  # POST /tar_bases or /tar_bases.json
  def create
    @objeto = TarBase.new(tar_bas_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Tar base was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_bases/1 or /tar_bases/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_bas_params)
        format.html { redirect_to @objeto, notice: "Tar base was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_bases/1 or /tar_bases/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to tar_bases_url, notice: "Tar base was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_bas
      @objeto = TarBase.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_bas_params
      params.require(:tar_bas).permit(:monto_uf, :monto, :owner_class, :owner_id, :perfil_id, :base)
    end
end
